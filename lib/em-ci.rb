$:.unshift(File.dirname(__FILE__))

require 'em-ci/version'
require 'cctray/project'
require 'cctray/server'

module EmCi

  def self.new *args
    EmCi.new *args
  end

  class EmCi
    def initialize url, frequency, options
      @server = CcTray::Server.new url, options
      @timer = EventMachine.add_periodic_timer(frequency) { run }

      @callbacks = {
        run: [],
      }
    end

    def run
      @server.run.then(proc {|projects|
        @callbacks[:run].each { |c| c.call(@server) }
      }, proc {|message| puts message})
    end

    def on_run(&block)
      @callbacks[:run] << block
    end
  end
end