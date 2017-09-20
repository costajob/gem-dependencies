module Lapidarius
  class Renderer
    class NoEntGemError< ArgumentError; end

    def initialize(gem, recursive = false)
      fail NoEntGemError, "gem not found on this system!" unless gem
      @gem = gem
      @recursive = recursive
      @out = []
    end

    def call(io = STDOUT)
      io.puts out
    end

    def out
      collect_header
      collect_body
      @out
    end

    private def collect_header
      @out << ("\n#{@gem.fullname}".ljust(28) << "#{@gem.deep_count}".rjust(3))
      @out << hr
    end

    private def collect_body
      return if @gem.deps.empty?
      @gem.deps.each do |dep|
        @out << dep.to_s(recursive: @recursive)
      end
      @out << "\n"
    end

    private def hr
      "#{"-" * 30}\n"
    end
  end
end
