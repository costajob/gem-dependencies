require "helper"

describe Lapidarius::Cutter do
  it "must cut gem with runtime dependencies" do
    cutter = Lapidarius::Cutter.new("sinatra", Stubs::Command)
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must compute development dependencies count" do
    cutter = Lapidarius::Cutter.new("sinatra", Stubs::Command)
    gem = cutter.call
    gem.dev_count.must_equal 5
  end

  it "must return nil if gem is not created" do
    cutter = Lapidarius::Cutter.new("raise_error", Stubs::Command)
    cutter.call.must_be_nil
  end
end
