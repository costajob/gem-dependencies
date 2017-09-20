require "stringio"

module Lapidarius
  class UI
    def initialize
      @io = StringIO.new
    end

    def say(statement)
      @io.puts statement
    end

    def out
      @io.string.strip
    end

    def clear!
      @io.reopen("")
    end
  end
end
