require "lapidarius/gem"
require "lapidarius/command"
require "rubygems/requirement"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    attr_reader :version, :remote

    def initialize(name:, cmd_klass: Command, version: nil, remote: false)
      @name = name
      @cmd = cmd_klass.new
      @version = version
      @remote = remote
      @dev_deps = []
    end

    def call
      recurse.tap do |gem|
        gem.dev_count = dev_count if gem
      end
    end

    private def recurse(name = @name, gem = nil, version = @version, remote = @remote)
      tokens = tokenize(name, version, remote)
      token = tokens.shift
      gem ||= Gem.factory(token)
      tokens.each do |t|
        next unless dep = Gem.factory(t)
        gem << dep
        recurse(dep.name, dep, nil, remote)
      end
      gem
    end

    def dev_count
      @dev_deps.map { |e| e.split(" ").first }.uniq.count
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
