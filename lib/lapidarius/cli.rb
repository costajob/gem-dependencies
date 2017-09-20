require "optparse"
require "lapidarius/cutter"
require "lapidarius/renderer"

module Lapidarius
  class CLI
    def initialize(args, io = STDOUT)
      @args = args
      @io = io
      @gem = nil
      @recursive = nil
    end

    def call(cmd_klass = Command)
      parser.parse!(@args)
      return @io.puts("specify gem name as: '-g gem_name'") unless @gem
      obj = Lapidarius::Cutter.new(@gem, cmd_klass).call
      Lapidarius::Renderer::new(obj, @recursive).call(@io)
    rescue Gem::NotInstalledError => e
      @io.puts e.message.sub("specified", "\e[1m#{@gem}\e[0m")
    end

    private def parser
      OptionParser.new do |opts|
        opts.banner = "Usage: ./bin/lapidarius --gem=sinatra --recursive"

        opts.on("-gGEM", "--gem=GEM", "The gem name to scan") do |gem|
          @gem = gem
        end

        opts.on("-r", "--recursive", "Print dependencies recursively") do |recursive|
          @recursive = recursive
        end

        opts.on("-h", "--help", "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end
  end
end

