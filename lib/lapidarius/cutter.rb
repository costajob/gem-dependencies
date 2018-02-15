require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    attr_reader :version, :remote

    def initialize(name:, cmd_klass: Command, version: nil, remote: nil)
      @name = name
      @cmd = cmd_klass.new
      @version = version
      @remote = remote
      @dev_deps = []
      @cache = {}
    end

    def call
      recurse.tap do |gem|
        gem.dev_count = dev_count if gem
      end
    end

    private def recurse(name: @name, gem: nil, version: @version)
      tokens = tokenize(name, version, @remote)
      parent = tokens.shift
      gem ||= Gem.factory(parent)
      tokens.reduce(gem) do |acc, token|
        acc << dependency(token); acc
      end
    end

    def dev_count
      @dev_deps.map { |e| e.split(" ").first }.uniq.count
    end

    private def dependency(token)
      @cache.fetch(token) do
        Gem.factory(token).tap do |dep|
          recurse(name: dep.name, gem: dep, version: dep.version)
          @cache[token] = dep
        end
      end
    end

    private def tokenize(name, version, remote)
      src = @cmd.call(name, version, remote)
      data = normalize(src)
      dev, tokens = data.partition { |token| token.match(/#{DEVELOPMENT}/) }
      @dev_deps.concat(dev)
      tokens
    end

    private def normalize(src)
      src.split(/\n\n/).map!(&:strip).first.split("\n").map(&:strip)
    end
  end
end
