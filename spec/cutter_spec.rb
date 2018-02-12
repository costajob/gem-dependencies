require "helper"

describe Lapidarius::Cutter do
  let(:cutter) { Lapidarius::Cutter.new(name: "sinatra", cmd_klass: Stubs::Command, version: "1.4.7") }

  it "must set command version" do
    cutter.version.must_equal "1.4.7"
  end

  it "must cut gem with runtime dependencies" do
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must compute development dependencies count" do
    gem = cutter.call
    gem.dev_count.must_equal 5
  end

  it "must return nil if gem is not created" do
    cutter = Lapidarius::Cutter.new(name: "raise_error", cmd_klass: Stubs::Command)
    cutter.call.must_be_nil
  end
end
