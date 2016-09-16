module Lapidarius
  class Renderer
    class NoEntGemError< ArgumentError; end

    HR_WIDTH = 35
    NBR_WIDTH = 3 

    def initialize(gem:, recursive: false)
      fail NoEntGemError, "gem not found on this system!" unless gem
      @gem = gem
      @recursive = recursive
      @out = []
    end

    def call(io = STDOUT)
      io.puts out
    end

    def out
      @out.tap do |out| 
        out << header
        [Env::RUNTIME, Env::DEVELOPMENT].each_with_index do |env, i|
          body(env, i)
        end
      end
    end

    private def header
      "\n#{@gem.name} (#{@gem.version}):\n\n"
    end

    private def body(env, index)
      group = deps_groups[index]
      return if group.empty?
      @out << title(env, group)
      group.each do |dep|
        @out << dep.to_s(recursive: @recursive)
      end
      @out << "\n"
    end

    private def title(env, group)
      "#{env} gems".ljust(HR_WIDTH - NBR_WIDTH) << "#{group.size}".rjust(NBR_WIDTH) << "\n" << hr
    end

    private def hr
      "#{"-" * HR_WIDTH}\n"
    end

    private def deps_groups
      return [@runtime_deps, @development_deps] if @runtime_deps && @development_deps 
      @runtime_deps, @development_deps = @gem.deps.partition { |dep| dep.env == Env::RUNTIME }
    end
  end
end
