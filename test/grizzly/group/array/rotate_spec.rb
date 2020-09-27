require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collection_rotate, shared: true do
  describe "when passed no argument" do
    it "returns a copy of the array with the first element moved at the end" do
      @subject.new([1, 2, 3, 4, 5]).rotate.should == [2, 3, 4, 5, 1]
    end
  end

  describe "with an argument n" do
    it "returns a copy of the array with the first (n % size) elements moved at the end" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.rotate(  2).should == [3, 4, 5, 1, 2]
      a.rotate( -1).should == [5, 1, 2, 3, 4]
      a.rotate(-21).should == [5, 1, 2, 3, 4]
      a.rotate( 13).should == [4, 5, 1, 2, 3]
      a.rotate(  0).should == a
    end

    it "coerces the argument using to_int" do
      @subject.new([1, 2, 3]).rotate(2.6).should == [3, 1, 2]

      obj = mock('integer_like')
      obj.should_receive(:to_int).and_return(2)
      @subject.new([1, 2, 3]).rotate(obj).should == [3, 1, 2]
    end

    it "raises a TypeError if not passed an integer-like argument" do
      -> {
        @subject.new([1, 2]).rotate(nil)
      }.should raise_error(TypeError)
      -> {
        @subject.new([1, 2]).rotate("4")
      }.should raise_error(TypeError)
    end
  end

  it "returns a copy of the array when its length is one or zero" do
    @subject.new([1]).rotate.should == [1]
    @subject.new([1]).rotate(2).should == [1]
    @subject.new([1]).rotate(-42).should == [1]
    @subject.new([ ]).rotate.should == []
    @subject.new([ ]).rotate(2).should == []
    @subject.new([ ]).rotate(-42).should == []
  end

  it "does not mutate the receiver" do
    -> {
      @subject.new([]).freeze.rotate
      @subject.new([2]).freeze.rotate(2)
      @subject.new([1,2,3]).freeze.rotate(-3)
    }.should_not raise_error
  end

  it "does not return self" do
    a = @subject.new([1, 2, 3])
    a.rotate.should_not equal(a)
    a = @subject.new([])
    a.rotate(0).should_not equal(a)
  end
  # New Interface

  # it "does not return subclass instance for Array subclasses" do
  #   CollectionSpecs::MyArray[1, 2, 3].rotate.should be_an_instance_of(Array)
  # end
end

describe :collection_rotate!, shared: true do
  describe "when passed no argument" do
    it "moves the first element to the end and returns self" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.rotate!.should equal(a)
      a.should == [2, 3, 4, 5, 1]
    end
  end

  describe "with an argument n" do
    it "moves the first (n % size) elements at the end and returns self" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.rotate!(2).should equal(a)
      a.should == [3, 4, 5, 1, 2]
      a.rotate!(-12).should equal(a)
      a.should == [1, 2, 3, 4, 5]
      a.rotate!(13).should equal(a)
      a.should == [4, 5, 1, 2, 3]
    end

    it "coerces the argument using to_int" do
      @subject.new([1, 2, 3]).rotate!(2.6).should == [3, 1, 2]

      obj = mock('integer_like')
      obj.should_receive(:to_int).and_return(2)
      @subject.new([1, 2, 3]).rotate!(obj).should == [3, 1, 2]
    end

    it "raises a TypeError if not passed an integer-like argument" do
      -> {
        @subject.new([1, 2]).rotate!(nil)
      }.should raise_error(TypeError)
      -> {
        @subject.new([1, 2]).rotate!("4")
      }.should raise_error(TypeError)
    end
  end

  it "does nothing and returns self when the length is zero or one" do
    a = @subject.new([1])
    a.rotate!.should equal(a)
    a.should == [1]
    a.rotate!(2).should equal(a)
    a.should == [1]
    a.rotate!(-21).should equal(a)
    a.should == [1]

    a = @subject.new([])
    a.rotate!.should equal(a)
    a.should == []
    a.rotate!(2).should equal(a)
    a.should == []
    a.rotate!(-21).should equal(a)
    a.should == []
  end

  it "raises a FrozenError on a frozen array" do
    -> { @subject.new([1, 2, 3]).freeze.rotate!(0) }.should raise_error(FrozenError)
    -> { @subject.new([1]).freeze.rotate!(42) }.should raise_error(FrozenError)
    -> { @subject.new([]).freeze.rotate! }.should raise_error(FrozenError)
  end
end


describe "Array#rotate" do
  before { @subject = Array }

  it_behaves_like :collection_rotate, :rotate
  it_behaves_like :collection_rotate!, :rotate!

  it "does not return subclass instance for Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].rotate.should be_an_instance_of(Array)
  end
end

describe "Collection#rotate" do
  before { @subject = Group }

  it_behaves_like :collection_rotate, :rotate
  it_behaves_like :collection_rotate!, :rotate!

  it "returns subclass instance for Array subclasses" do
    Group.new([1, 2, 3]).rotate.should be_an_instance_of(Group)
  end
end
