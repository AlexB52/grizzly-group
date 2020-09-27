require_relative '../../../spec_helper'


describe :collection_take_while, shared: true do
  it "returns all elements until the block returns false" do
    @subject.new([1, 2, 3]).take_while{ |element| element < 3 }.should == [1, 2]
  end

  it "returns all elements until the block returns nil" do
    @subject.new([1, 2, nil, 4]).take_while{ |element| element }.should == [1, 2]
  end

  it "returns all elements until the block returns false" do
    @subject.new([1, 2, false, 4]).take_while{ |element| element }.should == [1, 2]
  end
end

describe "Array#take_while" do
  before { @subject = Array }

  it_behaves_like :collection_take_while, :take_while
end

describe "Collection#take_while" do
  before { @subject = Group }

  it_behaves_like :collection_take_while, :take_while

  it "returns subclass instance for Array subclasses" do
    Group.new([1, 2, 3]).take(1).should be_an_instance_of(Group)
  end
end
