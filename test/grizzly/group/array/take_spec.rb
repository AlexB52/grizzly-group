require_relative '../../../spec_helper'


describe :collection_take, shared: true do
  it "returns the first specified number of elements" do
    @subject.new([1, 2, 3]).take(2).should == [1, 2]
  end

  it "returns all elements when the argument is greater than the Array size" do
    @subject.new([1, 2]).take(99).should == [1, 2]
  end

  it "returns all elements when the argument is less than the Array size" do
    @subject.new([1, 2]).take(4).should == [1, 2]
  end

  it "returns an empty Array when passed zero" do
    @subject.new([1]).take(0).should == []
  end

  it "returns an empty Array when called on an empty Array" do
    @subject.new([]).take(3).should == []
  end

  it "raises an ArgumentError when the argument is negative" do
    ->{ @subject.new([1]).take(-3) }.should raise_error(ArgumentError)
  end
end

describe "Array#take" do
  before { @subject = Array }

  it_behaves_like :collection_take, :take
end

describe "Collection#take" do
  before { @subject = Group }

  it_behaves_like :collection_take, :take

  it "returns subclass instance for Array subclasses" do
    Group.new([1, 2, 3]).take(1).should be_an_instance_of(Group)
  end
end
