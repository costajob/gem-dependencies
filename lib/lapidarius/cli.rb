require "lapidarius/cutter"

module Lapidarius
  class CLI
    HELP_FLAGS = %w[-h --help]
    COL_WIDTH = 23

    def initialize(input, 
                   pipe = STDOUT, 
                   command = Command,
                   cutter = Cutter,
                   tree = Tree)
      @input = input.to_s.strip
      @pipe = pipe
      @cutter = cutter.new(@input, command)
      @tree = tree
    end

    def call
      @pipe.puts output
    end

    private def output
      return help if help?
      return if @input.empty?
      gem = @cutter.call
      @tree::new(gem).out
    rescue Gem::NotInstalledError => e
      e.message.sub("specified", %Q{"#{@input}"})
    end

    private def help?
      HELP_FLAGS.include?(@input)
    end

    private def help
      [].tap do |h|
        h << %q{Usage: lapidarius sinatra}
        h << "    %-#{COL_WIDTH}s Print this help" % "-h --help"
        h << "    %-#{COL_WIDTH}s Gem's name to cut" % "<gem-name>"
      end
    end
  end
end
