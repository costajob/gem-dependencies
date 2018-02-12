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

    def call(gem, version = nil)
      @dep.ui.clear!
      version ? @dep.invoke(gem, '-v', version) : @dep.invoke(gem)
      @dep.ui.out
    end
  end
end

