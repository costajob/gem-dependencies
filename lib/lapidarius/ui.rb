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
 
    # mock method invocked by Gem::UserInteraction module
    def terminate_interaction(code = 0); end
  end
end
