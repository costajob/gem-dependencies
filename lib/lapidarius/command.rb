require "rubygems/commands/dependency_command"
require "rubygems/requirement"
require "lapidarius/ui"

module Lapidarius
  class Command
    attr_reader :dep

    def initialize(dep_klass: ::Gem::Commands::DependencyCommand, ui_klass: UI)
      @dep = dep_klass.new
      @dep.ui = ui_klass.new
    end

    def call(*args)
      @dep.ui.clear!
      @dep.invoke(*options(args))
      @dep.ui.out
    end

    private def options(args)
      name, version, remote = args 
      [name].tap do |args|
        args.concat(["-v", version]) if version
        args.concat(["-b", "-B", "10000"]) if remote
      end
    end
  end
end

