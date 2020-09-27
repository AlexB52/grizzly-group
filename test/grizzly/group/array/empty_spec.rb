require_relative '../../../spec_helper'


describe :collection_empty, shared: true do
  describe "#empty?" do
    it "returns true if the array has no elements" do
      @subject.new([]).empty?.should == true
      @subject.new([1]).empty?.should == false
      @subject.new([1, 2]).empty?.should == false
    end
  end
end

describe "Array#empty?" do
  before { @subject = Array }

  it_behaves_like :collection_empty, :empty
end

describe "Array#empty?" do
  before { @subject = Group }

  it_behaves_like :collection_empty, :empty
end
