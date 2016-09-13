require "lapidarius/env"

module Lapidarius
  class Gem
    include Env::Affected

    class KindError < ArgumentError; end

    def self.factory(name)
      name.match(/Gem ([a-z0-9\-_]+)-(\d{1,2}\.\d{1,3}\.\d{1,2})/) do |m|
        return new(name: m[1], version: m[2])
      end
      name.match(/([a-z0-9\-_]+) \(([0-9~<>,= \.]+)(?:, (development))?\)/) do |m|
        return new(name: m[1], version: m[2], env: m[3] || Env::RUNTIME)
      end
    end

    attr_reader :name, :version

    def initialize(name:, version:, env: Env::RUNTIME)
      @name = name
      @version = version
      @env = env
      @deps = []
    end

    def deps(env = :all)
      return @deps.clone if env == :all
      return @deps.select(&:runtime?) if env == Env::RUNTIME.to_sym
      return @deps.select(&:development?) if env == Env::DEVELOPMENT.to_sym
    end

    def <<(dep)
      fail KindError, "#{dep.inspect} is not a valid gem" unless gem?(dep)
      @deps << dep
    end

    def ==(gem)
      return false unless gem?(gem)
      gem.name == name && gem.version == version && gem.env == env
    end

    private def gem?(gem)
      %i{name version env deps}.all? { |msg| gem.respond_to?(msg) }
    end
  end
end
