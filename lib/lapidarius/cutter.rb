require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    def initialize(name, cmd_klass = Command)
      @name = name
      @cmd = cmd_klass.new
      @dev_deps = []
    end

    def call
      recurse.tap do |gem|
        gem.dev_count = dev_count if gem
      end
    end

    private def recurse(name = @name, gem = nil)
      tokens = tokenize(name)
      token = tokens.shift
      gem ||= Gem.factory(token)
      tokens.each do |t|
        next unless dep = Gem.factory(t)
        gem << dep
        recurse(dep.name, dep)
      end
      gem
    end

    def dev_count
      @dev_deps.map { |e| e.split(" ").first }.uniq.count
    end

    private def tokenize(name)
      src = @cmd.call(name)
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
