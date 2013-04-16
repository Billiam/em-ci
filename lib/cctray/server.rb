require 'ox'
require 'eventmachine'
require 'em-http'
require 'em-promise'

module CcTray
  class Server

    attr_accessor :url, :options, :projects

    def initialize(url, options = {})
      self.url = url
      self.options = options

      self.projects = {}
    end

    def run
      deferred = EventMachine::Q.defer

      http = request.get request_options
      http.errback { deferred.reject 'request failed' }
      http.callback {
        parse http.response
        deferred.resolve self.projects
      }

      deferred.promise
    end

    def [](name)
      projects[name]
    end

    #summary methods
    def sleeping?
      all?.(&:sleeping?)
    end

    def building?
      any?(&:building?)
    end

    def success?
      all?(&:success?)
    end

    def failure?
      any?(&:failure?)
    end

    protected

    # Generate a new request
    def request
      EventMachine::HttpRequest.new(url)
    end

    # Parse response XML, and break into projects
    def parse(data)
      data = Ox.parse(data)
      
      return unless data

      data = data.root if data.is_a?(Ox::Document)

      data.locate('Project').each do |project|
        attrs = project.attributes
        name = attrs[:name]
        next if options[:filter].is_a?(Array) && !options[:filter].include?(name)
        if self.projects.has_key? name
          self.projects[name].import attrs
        else
          self.projects[name] = Project.new attrs
        end
      end
    end

    def request_options
      opts = {}
      if options.has_key? :auth
        opts[:head] = { authorization: options[:auth] }
      end
      opts
    end

    def any? &block
      projects.each_value do |value|
        return true if block.call value
      end
      false
    end

    def all? &block
      projects.each_value do |value|
        return false unless block.call value
      end
      true
    end
  end
end
