require "optparse"
require "lapidarius/cutter"

module Lapidarius
  class CLI
    HELP_FLAGS = %w[-h --help]

    attr_reader :name, :version, :remote

    def initialize(args: [], io: STDOUT, command: Command, cutter: Cutter, tree: Tree)
      @args = args
      @io = io
      @command = command
      @cutter = cutter
      @tree = tree
      @name = @args.shift unless help?
      parser.parse!(@args)
    end

    def call
      @io.puts out
    end

    private def cutter
      @cutter.new(name: @name, cmd_klass: @command, version: @version, remote: @remote)
    end

    private def out
      return unless @name
      gem = cutter.call
      @tree::new(gem, @quiet).out
    rescue Gem::NotInstalledError, Gem::KindError => e
      e.message
    end

    private def parser
      OptionParser.new do |opts|
        opts.banner = %q{Usage: lapidarius sinatra --version=1.4.7 --remote --quiet}

        opts.on("-vVERSION", "--version=VERSION", "Specify the gem version to cut") do |version|
          @version = version
        end

        opts.on("-r", "--remote", "Fetch gem remotely") do |remote|
          @remote = true
        end

        opts.on("-q", "--quiet", "Hide dependencies tree") do |quiet|
          @quiet = true
        end

        opts.on(*HELP_FLAGS, "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end

    private def help?
      HELP_FLAGS.any? { |h| @args.first == h }
    end
  end
end
