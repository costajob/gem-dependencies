require "optparse"
require "lapidarius/cutter"

module Lapidarius
  class CLI
    attr_reader :name, :version, :remote

    def initialize(args: [], io: STDOUT, command: Command, cutter: Cutter, tree: Tree)
      @io = io
      @tree = tree
      parser.parse!(args)
      @cutter = cutter.new(name: @name, cmd_klass: command, version: @version, remote: @remote)
    end

    def call
      @io.puts output
    end

    private def output
      return unless @name
      gem = @cutter.call
      @tree::new(gem).to_s
    rescue Gem::NotInstalledError => e
      e.message
    end

    private def parser
      OptionParser.new do |opts|
        opts.banner = %q{Usage: lapidarius sinatra --version=1.4.7 --remote}

        opts.on("-nNAME", "--name=NAME", "Specify the gem name to cut") do |name|
          @name = name
        end

        opts.on("-vVERSION", "--version=VERSION", "Specify the gem version to cut") do |version|
          @version = version
        end

        opts.on("-r", "--remote", "Fetch gem remotely") do |remote|
          @remote = true
        end

        opts.on("-h", "--help", "Prints this help") do
          @io.puts opts
          exit
        end
      end
    end
  end
end
