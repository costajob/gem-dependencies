require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    class GemNotCreatedError < StandardError; end

    def initialize(gem:, version: nil, cmd_klass: Command)
      @gem = gem
      @version = version
      @cmd = cmd_klass.new
    end

    def call(src = cmd, gem = nil)
      tokens = tokenize(src)
      token = tokens.shift
      gem ||= Gem.factory(token)
      fail GemNotCreatedError, "unable to create a gem from #{token}" unless gem
      tokens.each do |t|
        dep = Gem.factory(t)
        next unless dep
        gem << dep
        call(cmd(dep.name), dep)
      end
      gem
    end

    private def tokenize(src)
      data = src.split(/\n\n/).map!(&:strip)
      by_version(data).split("\n").tap do |tokens|
        tokens.map!(&:strip)
        tokens.reject! { |token| token.match(/#{DEVELOPMENT}/) }
      end
    end

    private def by_version(data)
      data.detect { |d| d.match(/^Gem #{@gem}-#{@version}/) } || data.first
    end

    private def cmd(gem = @gem)
      @cmd.call(gem)
    end
  end
end
