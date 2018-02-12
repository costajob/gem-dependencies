require "lapidarius/cutter"

module Lapidarius
  class CLI
    HELP_FLAGS = %w[-h --help]
    COL_WIDTH = 23

    attr_reader :name, :version

    def initialize(input, 
                   out = STDOUT, 
                   command = Command,
                   cutter = Cutter,
                   tree = Tree)
      @name, @version = Array(input).map(&:strip)
      @out = out
      @cutter = cutter.new(name: @name, cmd_klass: command, version: @version)
      @tree = tree
    end

    def call
      @out.puts output
    end

    private def output
      return help if help?
      return unless @name
      gem = @cutter.call
      @tree::new(gem).to_s
    rescue Gem::NotInstalledError => e
      e.message
    end

    private def help?
      HELP_FLAGS.include?(@name)
    end

    private def help
      [].tap do |h|
        h << %q{Usage: lapidarius <name> <version>}
        h << "    %-#{COL_WIDTH}s Print this help" % "-h --help"
        h << "    %-#{COL_WIDTH}s Gem's name to cut" % "<name>"
        h << "    %-#{COL_WIDTH}s Gem's version to cut" % "<version>"
      end
    end
  end
end
