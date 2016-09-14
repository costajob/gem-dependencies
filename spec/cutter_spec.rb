require "spec_helper"

describe Lapidarius::Cutter do
  it "must cut gem with runtime dependencies" do
    cutter = Lapidarius::Cutter.new(gem: "sinatra", cmd_klass: Mocks::Command)
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must cut gem with all dependencies" do
    cutter = Lapidarius::Cutter.new(gem: "sinatra", include_dev: true, cmd_klass: Mocks::Command)
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
