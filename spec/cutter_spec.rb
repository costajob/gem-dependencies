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
end
