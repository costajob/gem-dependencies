module Stubs
  def self.data(gem)
    case gem
    when "sinatra"
      "Gem sinatra-1.4.7\n  rack (~> 1.5)\n  rack-protection (~> 1.4)\n  tilt (< 3, >= 1.3)\n  lapidarius (>= 0, development)\n\n"
    when "rack"
      "Gem rack-1.6.4\n  bacon (>= 0, development)\n  rake (>= 0, development)\n\n  Gem rack-2.0.1\n  concurrent-ruby (>= 0, development)\n  minitest (~> 5.0, development)\n  minitest-sprint (>= 0, development)\n  rake (>= 0, development)\n\n"
    when "rack-protection"
      "Gem rack-protection-1.5.3\n  rack (>= 0)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\n\n"
    when "tilt"
      "Gem tilt-2.0.5\n\n"
    when "lapidarius"
      "Gem lapidarius-1.0\n  rr (~> 1.5)\n\n"
    when "rake"
      "Gem rake-10.4.2\n  hoe (~> 3.13, development)\n  minitest (~> 5.4, development)\n  rdoc (~> 4.0, development)\n\n"
    when "minitest"
      "Gem minitest-5.8.3\n  hoe (~> 3.14, development)\n  rdoc (~> 4.0, development)\n\n  Gem minitest-5.9.0\n  hoe (~> 3.15, development)\n  rdoc (~> 4.0, development)\n\n"
    when "rdoc"
      "Gem rdoc-4.2.1\n\n"
    when "RubyInline"
      "Gem RubyInline-3.12.4\n  ZenTest (~> 4.3)\n  hoe (~> 3.13, development)\n  minitest (~> 5.6, development)\n  rdoc (~> 4.0, development)\n\n"
    when "raise_error"
      "Jem and the holograms"
    else
      "No gems found matching #{gem} (>= 0)"
    end
  end

  class Dependency
    attr_accessor :ui
    attr_reader :args

    def invoke(*args)
      @args = args
      data = Stubs.data(@args[0])
      ui.say(data)
    end
  end

  class Command
    def call(gem, version = nil, remote = nil)
      Stubs.data(gem)
    end
  end

  module Gems
    extend self

    def minitest
      Lapidarius::Gem.new(name: "minitest", version: "~> 5.4")
    end

    def rack
      Lapidarius::Gem.new(name: "rack", version: "~> 1.5", deps: [minitest])
    end

    def rack_protection
      Lapidarius::Gem.new(name: "rack-protection", version: "~> 1.4")
    end

    def tilt
      Lapidarius::Gem.new(name: "tilt", version: "< 3, >= 1.3")
    end

    def sinatra
      Lapidarius::Gem.new(name: "sinatra", version: "1.4.7", deps: [tilt, rack, rack_protection])
    end
  end
end
