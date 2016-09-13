require "spec_helper"

describe Lapidarius::Cutter do
  before do
    class Lapidarius::Cutter
      def cmd(gem = @gem)
        case gem
        when "sinatra"
          "Gem sinatra-1.4.7\n  rack (~> 1.5)\n  rack-protection (~> 1.4)\n  tilt (< 3, >= 1.3)\n\n"
        when "rack"
          "Gem rack-1.6.4\n  bacon (>= 0, development)\n  rake (>= 0, development)\n\n"
        when "rack-protection"
          "Gem rack-protection-1.5.3\n  rack (>= 0)\n  rack-test (>= 0, development)\n  rspec (~> 2.0, development)\n\n"
        when "tilt"
          "Gem tilt-2.0.5\n\n"
        when "rake"
          "Gem rake-10.4.2\n  hoe (~> 3.13, development)\n  minitest (~> 5.4, development)\n  rdoc (~> 4.0, development)\n\n"
        when "minitest"
          "Gem minitest-5.8.3\n  hoe (~> 3.14, development)\n  rdoc (~> 4.0, development)\n\n  Gem minitest-5.9.0\n  hoe (~> 3.15, development)\n  rdoc (~> 4.0, development)\n\n"
        when "rdoc"
          "Gem rdoc-4.2.1\n\n"
        else
          "No gems found matching #{gem} (>= 0)"
        end
      end
    end
  end

  it "must cut gem with runtime dependencies" do
    cutter = Lapidarius::Cutter.new(gem: "sinatra")
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must cut gem with all dependencies" do
    cutter = Lapidarius::Cutter.new(gem: "sinatra", include_dev: true)
    gem = cutter.call
    rack = gem.deps[0]
    rack.must_be_instance_of Lapidarius::Gem
    rack.deps.size.must_equal 2
    rack.deps(:development).each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
      assert dep.deps.all? { |d| d.instance_of?(Lapidarius::Gem) }
    end
  end
end
