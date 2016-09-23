module Lapidarius
  class Gem
    class KindError < ArgumentError; end

    LEVEL_DEPTH = 5

    def self.factory(name)
      name.match(/Gem ([a-z0-9\-_]+)-(.+)/) do |m|
        return new(name: m[1], version: m[2])
      end
      name.match(/([a-z0-9\-_]+) \(([0-9~<>=, \.]+)\)/) do |m|
        return new(name: m[1], version: m[2])
      end
    end

    attr_reader :name, :version, :deps

    def initialize(name:, version:, deps: [])
      @name = name
      @version = version
      @deps = deps
    end

    def <<(dep)
      fail KindError, "#{dep.inspect} is not a valid gem" unless gem?(dep)
      @deps << dep
    end

    def ==(gem)
      return false unless gem?(gem)
      gem.name == name && gem.version == version
    end

    def to_s(recursive: false)
      return fullname unless recursive
      fullname.tap do |s|
        deps.each do |dep|
          s << "\n"
          s << indentation
          s << dep.to_s(recursive: recursive)
        end
      end
    end

    def fullname
      "#{name} (#{version})"
    end

    def deep_count
      flatten_deps.size
    end

    protected def flatten_deps
      deps.reduce(deps) do |acc, dep|
        acc.concat dep.flatten_deps
      end.tap do |deps|
        deps.flatten!
        deps.uniq!(&:name)
      end
    end

    private def indentation
      " " * (caller.size / LEVEL_DEPTH)
    end

    private def gem?(gem)
      %i{name version deps}.all? { |msg| gem.respond_to?(msg) }
    end
  end
end
