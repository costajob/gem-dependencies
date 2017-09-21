require "helper"

describe Lapidarius::Tree do
  let(:tree) { Lapidarius::Tree.new(Stubs::Gems::sinatra) }

  it "must collect dependencies" do
    tree.out.size.must_equal 7
  end

  it "must prepend dependencies with proper prefix" do
    tree.out[0].must_equal Stubs::Gems::sinatra
    tree.out[1].start_with?(Lapidarius::Tree::NESTED).must_equal true
    tree.out[2].start_with?(Lapidarius::Tree::NESTED).must_equal true
    tree.out[3].start_with?(Lapidarius::Tree::STRAIGHT).must_equal true
    tree.out[4].start_with?(Lapidarius::Tree::CURVED).must_equal true
    tree.out[5].must_be_empty
    tree.out[6].start_with?(Stubs::Gems::sinatra.count.to_s).must_equal true
  end
end
