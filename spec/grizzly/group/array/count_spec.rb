require_relative '../../../spec_helper'


describe :collection_count, shared: true do
  it "returns the number of elements" do
    @subject.new([:a, :b, :c]).count.should == 3
  end

  it "returns the number of elements that equal the argument" do
    @subject.new([:a, :b, :b, :c]).count(:b).should == 2
  end

  it "returns the number of element for which the block evaluates to true" do
    @subject.new([:a, :b, :c]).count { |s| s != :b }.should == 2
  end
end

describe "Collection#count" do
  before { @subject = Group }

  it_behaves_like :collection_count, :count
end

describe "Array#count" do
  before { @subject = Array }

  it_behaves_like :collection_count, :count
end
