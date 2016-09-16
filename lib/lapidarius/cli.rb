require "optparse"
require "lapidarius/cutter"
require "lapidarius/renderer"

module Lapidarius
  class CLI
    class NoGemError < ArgumentError; end

    def initialize(args, io = STDOUT)
      @args = args
      @io = io
    end

    def call(cmd_klass = Command)
      parser.parse!(@args)
      fail NoGemError, "please specify the name of an installed gem!" unless @gem
      gem = cutter(cmd_klass).call
      renderer(gem).call(@io)
    end

    private def parser
      OptionParser.new do |opts|
        opts.banner = "Usage: ./bin/lapidarius --gem=sinatra --recursive --development"

        opts.on("-gGEM", "--gem=GEM", "The gem name to scan") do |gem|
          @gem = gem
        end

        opts.on("-r", "--recursive", "Print dependencies recursively") do |recursive|
          @recursive = recursive
        end

        opts.on("-d", "--development", "Include development dependencies") do |include_dev|
          @include_dev = include_dev
        end

        opts.on("-h", "--help", "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end

    private def cutter(cmd_klass)
      @cutter = Lapidarius::Cutter.new(gem: @gem, cmd_klass: cmd_klass, include_dev: @include_dev)
    end

    private def renderer(gem)
      Lapidarius::Renderer::new(gem: gem, recursive: @recursive)
    end
  end
end

