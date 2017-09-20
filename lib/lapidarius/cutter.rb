require "lapidarius/gem"
require "lapidarius/command"

module Lapidarius
  class Cutter
    DEVELOPMENT = "development"

    class GemNotCreatedError < StandardError; end

    def initialize(name, cmd_klass = Command)
      @name = name
      @cmd = cmd_klass.new
    end

    def call(name = @name, gem = nil)
      tokens = tokenize(name)
      token = tokens.shift
      gem ||= Gem.factory(token)
      fail GemNotCreatedError, "unable to create a gem from #{token}" unless gem
      tokens.each do |t|
        dep = Gem.factory(t)
        next unless dep
        gem << dep
        call(dep.name, dep)
      end
      gem
    end

    private def tokenize(name)
      src = @cmd.call(name)
      data = src.split(/\n\n/).map!(&:strip)
      data.first.split("\n").tap do |tokens|
        tokens.map!(&:strip)
        tokens.reject! { |token| token.match(/#{DEVELOPMENT}/) }
      end
    end
  end
end
