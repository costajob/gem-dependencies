require "gem_dependencies/dependency"

module GemDependencies
  class Runner
    def initialize(name)
      @name = name
    end

    private def call(name = @name)
      %x(gem dep #{name})
    end
  end
end
