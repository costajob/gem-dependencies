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

  it "must cut specified version only" do
    %w[2.0 1.6.4].each do |version|
      cutter = Lapidarius::Cutter.new(gem: "rack", version: version, cmd_klass: Mocks::Command)
      gem = cutter.call
      gem.must_be_instance_of Lapidarius::Gem
      gem.version.must_match(/^#{version}/)
    end
  end

  it "must raise an error if unable to create the gem" do
    cutter = Lapidarius::Cutter.new(gem: "raise_error", cmd_klass: Mocks::Command)
    -> { cutter.call }.must_raise Lapidarius::Cutter::GemNotCreatedError
  end
end
