require "optparse"
require "lapidarius/version"
require "lapidarius/cutter"
require "lapidarius/renderer"

module Lapidarius
  class CLI
    class NoGemError < ArgumentError; end

    def initialize(args, io = STDOUT)
      @args = args
      @io = io
      @gem = nil
      @recursive = nil
    end

    def call(cmd_klass = Command)
      parser.parse!(@args)
      fail NoGemError, "please specify the name of a gem: '-g gem_name'" unless @gem
      gem = cutter(cmd_klass).call
      renderer(gem).call(@io)
    rescue Gem::NotInstalledError => e
      @io.puts e.message.sub("specified", @gem)
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

        opts.on("-v", "--version", "Print library version") do
          @io.puts VERSION
          exit
        end
        
        opts.on("-h", "--help", "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end

    private def cutter(cmd_klass)
      @cutter = Lapidarius::Cutter.new(gem: @gem, cmd_klass: cmd_klass)
    end

    private def renderer(gem)
      Lapidarius::Renderer::new(gem: gem, recursive: @recursive)
    end
  end
end

