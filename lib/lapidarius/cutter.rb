require "lapidarius/gem"
require "lapidarius/command"
require "rubygems/requirement"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    attr_reader :version

    def initialize(name:, cmd_klass: Command, version: nil)
      @name = name
      @cmd = cmd_klass.new
      @version = version
      @dev_deps = []
    end

    def call
      recurse.tap do |gem|
        gem.dev_count = dev_count if gem
      end
    end

    private def recurse(name = @name, gem = nil, version = @version)
      tokens = tokenize(name, version)
      token = tokens.shift
      gem ||= Gem.factory(token)
      tokens.each do |t|
        next unless dep = Gem.factory(t)
        gem << dep
        recurse(dep.name, dep, nil)
      end
      gem
    end

    def dev_count
      @dev_deps.map { |e| e.split(" ").first }.uniq.count
    end

    private def tokenize(name, version)
      src = @cmd.call(name, version)
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
