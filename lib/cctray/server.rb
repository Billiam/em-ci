require "nokogiri"
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

      http = request.get
      http.errback { deferred.reject 'request failed' }
      http.callback {
        parse http.response
        deferred.resolve self.products
      }

      deferred.promise
    end

    def [](name)
      projects[name]
    end

    #summary methods
    def sleeping?
      all? { |p| yield project.sleeping? }
    end

    def building?
      any? { |p| yield project.building? }
    end

    def success?
      all? { |p| yield project.success? }
    end

    def failure?
      any? { |p| yield project.failure? }
    end

    protected

    # Generate a new request
    def request
      EventMachine::HttpRequest.new(url, request_options)
    end

    # Parse response XML, and break into projects
    def parse(data)
      Nokogiri::XML(document).xpath("/Projects/Project").each do |project|
        name = project['name']

        next if options.has_key?(:filter) && ! options[:filter].include?(name)

        if self.projects.has_key? project['name']
          projects[project['name']].import project
        else
          projects[project['name']] = Project.new project
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
        return true if block.call
      end
      false
    end

    def all? &block
      filtered_products.each_value do |value|
        return false unless block.call
      end
      true
    end
  end
end
