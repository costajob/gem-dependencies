module Lapidarius
  class Renderer
    class NoEntGemError< ArgumentError; end

    NO_DEPENDENCIES = "\ngem has no dependencies...\n\n"

    def initialize(gem)
      fail NoEntGemError, "gem not found on this system!" unless gem
      @gem = gem
      @out = []
    end

    def call(io = STDOUT)
      io.puts out
    end

    def out
      return @out unless @out.empty?
      return NO_DEPENDENCIES unless deps?
      @out.tap do |out| 
        out << header
        [Env::RUNTIME, Env::DEVELOPMENT].each do |env|
          body(env)
        end
      end
    end

    private def header
      "\n#{@gem.name} (#{@gem.version}):\n\n"
    end

    private def title(env)
      "\n#{env} gems".ljust(23) << "#{deps(env).size}".rjust(3) << "\n" << hr
    end

    private def hr
      "#{"-" * 25}\n\n"
    end

    private def body(env)
      return unless deps?(env)
      @out << title(env)
      deps(env).each do |dep|
        @out << dep.to_s
      end
    end

    private def deps(env = :all)
      @deps ||= footprint
      return @deps if env == :all
      @deps.select { |dep| dep.env == env }
    end

    private def deps?(env = :all)
      return !deps.empty? if env == :all
      !deps(env).empty?
    end

    private def footprint(gem = @gem)
      deps = gem.deps.reduce(gem.deps.clone) do |acc, dep|
        acc << footprint(dep)
      end
      deps.flatten!
      deps.uniq!(&:name)
      deps
    end
  end
end
