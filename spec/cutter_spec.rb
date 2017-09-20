require "spec_helper"

describe Lapidarius::Cutter do
  it "must cut gem with runtime dependencies" do
    cutter = Lapidarius::Cutter.new("sinatra", Mocks::Command)
    gem = cutter.call
    gem.must_be_instance_of Lapidarius::Gem
    gem.deps.size.must_equal 3
    gem.deps.each do |dep|
      dep.must_be_instance_of Lapidarius::Gem
    end
  end

  it "must raise an error if unable to create the gem" do
    cutter = Lapidarius::Cutter.new("raise_error", Mocks::Command)
    -> { cutter.call }.must_raise Lapidarius::Cutter::GemNotCreatedError
  end
end
