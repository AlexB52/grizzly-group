require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_first, shared: true do
  it "returns the first element" do
    @subject.new(%w{a b c}).first.should == 'a'
    @subject.new([nil]).first.should == nil
  end

  it "returns nil if self is empty" do
    @subject.new([]).first.should == nil
  end

  it "returns the first count elements if given a count" do
    @subject.new([true, false, true, nil, false]).first(2).should == [true, false]
  end

  it "returns an empty array when passed count on an empty array" do
    @subject.new([]).first(0).should == []
    @subject.new([]).first(1).should == []
    @subject.new([]).first(2).should == []
  end

  it "returns an empty array when passed count == 0" do
    @subject.new([1, 2, 3, 4, 5]).first(0).should == []
  end

  it "returns an array containing the first element when passed count == 1" do
    @subject.new([1, 2, 3, 4, 5]).first(1).should == [1]
  end

  it "raises an ArgumentError when count is negative" do
    -> { @subject.new([1, 2]).first(-1) }.should raise_error(ArgumentError)
  end

  it "raises a RangeError when count is a Bignum" do
    -> { @subject.new([]).first(bignum_value) }.should raise_error(RangeError)
  end

  it "returns the entire array when count > length" do
    @subject.new([1, 2, 3, 4, 5, 9]).first(10).should == [1, 2, 3, 4, 5, 9]
  end

  it "returns an array which is independent to the original when passed count" do
    ary = @subject.new [1, 2, 3, 4, 5]
    ary.first(0).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
    ary.first(1).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
    ary.first(6).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.first.should equal(empty)

    ary = CollectionSpecs.head_recursive_array(@subject)
    ary.first.should equal(ary)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(2)
    @subject.new([1, 2, 3, 4, 5]).first(obj).should == [1, 2]
  end

  it "raises a TypeError if the passed argument is not numeric" do
    -> { @subject.new([1,2]).first(nil) }.should raise_error(TypeError)
    -> { @subject.new([1,2]).first("a") }.should raise_error(TypeError)

    obj = mock("nonnumeric")
    -> { @subject.new([1,2]).first(obj) }.should raise_error(TypeError)
  end

  it "is not destructive" do
    a = @subject.new [1, 2, 3]
    a.first
    a.should == [1, 2, 3]
    a.first(2)
    a.should == [1, 2, 3]
    a.first(3)
    a.should == [1, 2, 3]
  end
end

describe "Array#first" do
  before { @subject = Array }

  it_behaves_like :collection_first, :first

  it "does not return subclass instance when passed count on Array subclasses" do
    CollectionSpecs::MyArray[].first(0).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[].first(2).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].first(0).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].first(1).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].first(2).should be_an_instance_of(Array)
  end
end

describe "Collection#first" do
  before { @subject = Group }

  it_behaves_like :collection_first, :first

  it "returns a Collection subclass instance when passed count on Array subclasses" do
    # TODO: Investigate the subclassing
    @subject.new(CollectionSpecs::MyArray[]).first(0).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[]).first(2).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).first(0).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).first(1).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).first(2).should be_an_instance_of(Group)
  end
end