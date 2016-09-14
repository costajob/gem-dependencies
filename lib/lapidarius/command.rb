require "rubygems/commands/dependency_command"
require "lapidarius/ui"

module Lapidarius
  class Command
    def initialize(dep_klass: ::Gem::Commands::DependencyCommand, ui_klass: UI)
      @dep = dep_klass.new
      @dep.ui = ui_klass.new
    end

    def call(gem)
      @dep.ui.clear!
      @dep.invoke(gem)
      @dep.ui.out
    end
  end
end

