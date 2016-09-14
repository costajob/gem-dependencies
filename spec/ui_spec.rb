require "spec_helper"

describe Lapidarius::UI do
  let(:ui) { Lapidarius::UI.new }
  let(:verse) { "you say goodbye, i say hello!" }

  it "must say something" do
    ui.say verse
    ui.out.must_equal verse
  end


  it "must clear output" do
    ui.say verse
    ui.clear!
    ui.out.must_be_empty
  end
end
