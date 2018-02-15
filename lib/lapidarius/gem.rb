require "forwardable"
require "lapidarius/tree"

module Lapidarius
  class Gem
    INVALID_VER_CHARS = %w[> < = ~ !]
    DEFAULT_VER = ">= 0"

    extend Forwardable

    def_delegators :@deps, :size, :each_with_index

    class KindError < ArgumentError; end
    class NotInstalledError < ArgumentError; end

    def self.factory(token)
      token.match(/^No gems found matching/) do |m|
        fail NotInstalledError, token.gsub(/\/|\^|\$/, '')
      end
      token.match(/Gem ([a-zA-Z0-9\-_]+)-(.+)/) do |m|
        return new(name: m[1], version: m[2])
      end
      token.match(/([a-zA-Z0-9\-_]+) \((.+)\)/) do |m|
        return new(name: m[1], version: m[2])
      end
      fail KindError, "no gem can be created from #{token}"
    end

    attr_reader :name, :deps
    attr_accessor :dev_count

    def initialize(name:, version:, deps: [])
      @name = name
      @version_raw = version
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

    def to_s
      "#{name} (#{@version_raw})"
    end

    def count
      flatten_deps.size
    end

    def version
      return @version if @version
      stripped = @version_raw.gsub(/#{INVALID_VER_CHARS.join("|")}/, "")
      tokens = stripped.split(",").map(&:strip)
      min = tokens.min
      @version = min.to_f.zero? ? DEFAULT_VER : min
    end

    protected def flatten_deps
      deps.reduce(deps) do |acc, dep|
        acc.concat dep.flatten_deps
      end.tap do |deps|
        deps.flatten!
        deps.uniq!(&:name)
      end
    end

    private def gem?(gem)
      %i{name version deps}.all? { |msg| gem.respond_to?(msg) }
    end
  end
end
