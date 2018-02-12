require "helper"

describe Lapidarius::Tree do
  let(:tree) { Lapidarius::Tree.new(Stubs::Gems::sinatra) }

  it "must collect dependencies" do
    tree.to_s.size.must_equal 7
  end

  it "must prepend dependencies with proper prefix" do
    tree.to_s[0].must_equal Stubs::Gems::sinatra
    tree.to_s[1].start_with?(Lapidarius::Tree::NESTED).must_equal true
    tree.to_s[2].start_with?(Lapidarius::Tree::NESTED).must_equal true
    tree.to_s[3].start_with?(Lapidarius::Tree::STRAIGHT).must_equal true
    tree.to_s[4].start_with?(Lapidarius::Tree::CURVED).must_equal true
    tree.to_s[5].must_be_empty
    tree.to_s[6].start_with?(Stubs::Gems::sinatra.count.to_s).must_equal true
  end
end
