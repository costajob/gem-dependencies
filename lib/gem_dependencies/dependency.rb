module GemDependencies
  class Dependency
    module Type 
      %w[runtime development].each do |type|
        const_set(type.upcase, type)
      end
    end

    def self.factory(name)
      name.match(/Gem ([a-z\-_]+)-(\d{1,2}\.\d{1,3}\.\d{1,2})/) do |m|
        return new(name: m[1], version: m[2])
      end
      name.match(/([a-z\-_]+) \(([0-9~<>,= \.]+)(?:, (#{Type::DEVELOPMENT}))?\)/) do |m|
        return new(name: m[1], version: m[2], type: m[3] || Type::RUNTIME)
      end
    end

    attr_reader :name, :version, :type

    def initialize(name:, version:, type: Type::RUNTIME)
      @name = name
      @version = version
      @type = type
    end

    def ==(o)
      return false unless o.instance_of?(Dependency)
      o.name == name && o.version == version && o.type == type
    end
  end
end
