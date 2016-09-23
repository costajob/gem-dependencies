require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    class GemNotCreatedError < StandardError; end

    def initialize(gem:, cmd_klass: Command)
      @gem = gem
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
      src = src.split(/\n\n/).first
      src.split("\n").tap do |tokens|
        tokens.map!(&:strip)
        tokens.reject! { |token| token.match(/#{DEVELOPMENT}/) }
      end
    end

    private def cmd(gem = @gem)
      @cmd.call(gem)
    end
  end
end
