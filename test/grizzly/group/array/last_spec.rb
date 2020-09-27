require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_last, shared: true do
  it "returns the last element" do
    @subject.new([1, 1, 1, 1, 2]).last.should == 2
  end

  it "returns nil if self is empty" do
    @subject.new([]).last.should == nil
  end

  it "returns the last count elements if given a count" do
    @subject.new([1, 2, 3, 4, 5, 9]).last(3).should == [4, 5, 9]
  end

  it "returns an empty array when passed a count on an empty array" do
    @subject.new([]).last(0).should == []
    @subject.new([]).last(1).should == []
  end

  it "returns an empty array when count == 0" do
    @subject.new([1, 2, 3, 4, 5]).last(0).should == []
  end

  it "returns an array containing the last element when passed count == 1" do
    @subject.new([1, 2, 3, 4, 5]).last(1).should == [5]
  end

  it "raises an ArgumentError when count is negative" do
    -> { @subject.new([1, 2]).last(-1) }.should raise_error(ArgumentError)
  end

  it "returns the entire array when count > length" do
    @subject.new([1, 2, 3, 4, 5, 9]).last(10).should == [1, 2, 3, 4, 5, 9]
  end

  it "returns an array which is independent to the original when passed count" do
    ary = @subject.new [1, 2, 3, 4, 5]
    ary.last(0).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
    ary.last(1).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
    ary.last(6).replace([1,2])
    ary.should == [1, 2, 3, 4, 5]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.last.should equal(empty)

    array = CollectionSpecs.recursive_array(@subject)
    array.last.should equal(array)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(2)
    @subject.new([1, 2, 3, 4, 5]).last(obj).should == [4, 5]
  end

  it "raises a TypeError if the passed argument is not numeric" do
    -> { @subject.new([1,2]).last(nil) }.should raise_error(TypeError)
    -> { @subject.new([1,2]).last("a") }.should raise_error(TypeError)

    obj = mock("nonnumeric")
    -> { @subject.new([1,2]).last(obj) }.should raise_error(TypeError)
  end

  it "is not destructive" do
    a = @subject.new [1, 2, 3]
    a.last
    a.should == [1, 2, 3]
    a.last(2)
    a.should == [1, 2, 3]
    a.last(3)
    a.should == [1, 2, 3]
  end
end
describe "Array#last" do
  before {  @subject = Array }

  it_behaves_like :collection_last, :last

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[].last(0).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[].last(2).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].last(0).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].last(1).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].last(2).should be_an_instance_of(Array)
  end
end

describe "Collection#last" do
  before { @subject = Group }

  it_behaves_like :collection_last, :last

  it "returns a Collection instance on Array subclasses" do
    # TODO: Investigate the Array but
    @subject.new(CollectionSpecs::MyArray[]).last(0).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[]).last(2).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).last(0).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).last(1).should be_an_instance_of(Group)
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).last(2).should be_an_instance_of(Group)
  end
end