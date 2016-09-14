module Lapidarius
  class Renderer
    class NoEntGemError< ArgumentError; end

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
      @deps ||= footprint
      runtime = @deps.select(&:runtime?)
      development = @deps.select(&:development?)
      @out << "\n"
      @out << hr("#{@gem.name} (#{@gem.version})")
      @out << "  runtime gems:".ljust(23) + "#{runtime.size}\n"
      @out << "  development gems:".ljust(23) + "#{development.size}\n\n"
      if !runtime.empty?
        @out << hr("runtime gems:")
        runtime.each do |dep|
          @out << dep.to_s
        end
      end
      if !development.empty?
        @out << hr("development gems:")
        development.each do |dep|
          @out << dep.to_s
        end
      end
      @out
    end

    private def hr(title = nil)
      "#{title}\n#{"-" * 25}\n"
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
