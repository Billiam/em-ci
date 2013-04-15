$:.unshift(File.dirname(__FILE__))

require 'em-ci/version'
require 'cctray/project'
require 'cctray/server'

module EmCi

  def self.new *args
    EmCi.new *args
  end

  class EmCi
    def initialize(url, options)
      @server = CcTray::Server.new url, options

      @callbacks = {
        run: [],
      }
    end

    def start(frequency)
      run
      @timer = EventMachine.add_periodic_timer(frequency) { run }
    end

    def run
      @server.run.then(
        lambda { |projects|
          @callbacks[:run].each { |c| c.call(@server) }
        },
        lambda { |message| puts message }
      )
    end

    def on_run(&block)
      @callbacks[:run] << block
    end
  end
end