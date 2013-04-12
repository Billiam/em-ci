$:.unshift(File.dirname(__FILE__))

require 'em-ci/version'
require 'cctray/project'
require 'cctray/cctray'

module EmCi

  def self.new *args
    EmCi.new *args
  end

  class EmCi
    def initialize lights, url, frequency, options
      @server = CcTray::Server url, options
      @timer = EventMachine.add_periodic_timer frequency { run }
      @lights = Array(lights)

      @callbacks = {
        run: [],
      }
    end

    def run
      @server.run.then do |projects|
        @callbacks[:run].each { |c| c.call(@server) }
      end
    end

    def on_run(&block)
      @callbacks[:run] << block
    end
  end
end