require "optparse"
require "lapidarius/cutter"

module Lapidarius
  class CLI
    HELP_FLAGS = %w[-h --help]

    attr_reader :name, :version, :remote

    def initialize(args: [], io: STDOUT, command: Command, cutter: Cutter, 
                   tree: Tree, spinner: Spinner.new)
      @args = args
      @io = io
      @command = command
      @cutter = cutter
      @tree = tree
      @spinner = spinner
      @name = @args.shift unless help?
      parser.parse!(@args)
    end

    def call
      @spinner.call do
        @output = cut
      end
      @io.puts @output
    end

    private def cutter
      @cutter.new(name: @name, cmd_klass: @command, version: @version, remote: @remote)
    end

    private def cut
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

  class Spinner
    CHARS = %w[| / - \\]

    def initialize(io = STDOUT, fps = 15, delay = 1.0)
      @io = io
      @fps = fps.to_i
      @delay = delay.to_f / @fps
      @iter = 0
    end

    def call
      spinner = Thread.new do
        while @iter do
          @io.print CHARS[(@iter+=1) % CHARS.length]
          sleep @delay
          @io.print "\b"
          @io.flush
        end
      end
    ensure
      yield.tap do
        @iter = false
        spinner.join
      end
    end
  end
end
