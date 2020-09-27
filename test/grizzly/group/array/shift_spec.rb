require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collection_shift, shared: true do
  it "removes and returns the first element" do
    a = @subject.new([5, 1, 1, 5, 4])
    a.shift.should == 5
    a.should == [1, 1, 5, 4]
    a.shift.should == 1
    a.should == [1, 5, 4]
    a.shift.should == 1
    a.should == [5, 4]
    a.shift.should == 5
    a.should == [4]
    a.shift.should == 4
    a.should == []
  end

  it "returns nil when the array is empty" do
    @subject.new([]).shift.should == nil
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.shift.should == []
    empty.should == []

    array = CollectionSpecs.recursive_array(@subject)
    array.shift.should == 1
    array[0..2].should == ['two', 3.0, array]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).shift }.should raise_error(FrozenError)
  end
  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).shift }.should raise_error(FrozenError)
  end

  describe "passed a number n as an argument" do
    it "removes and returns an array with the first n element of the array" do
      a = @subject.new([1, 2, 3, 4, 5, 6])

      a.shift(0).should == []
      a.should == [1, 2, 3, 4, 5, 6]

      a.shift(1).should == [1]
      a.should == [2, 3, 4, 5, 6]

      a.shift(2).should == [2, 3]
      a.should == [4, 5, 6]

      a.shift(3).should == [4, 5, 6]
      a.should == []
    end

    it "does not corrupt the array when shift without arguments is followed by shift with an argument" do
      a = @subject.new([1, 2, 3, 4, 5])

      a.shift.should == 1
      a.shift(3).should == [2, 3, 4]
      a.should == [5]
    end

    it "returns a new empty array if there are no more elements" do
      a = @subject.new([])
      popped1 = a.shift(1)
      popped1.should == []
      a.should == []

      popped2 = a.shift(2)
      popped2.should == []
      a.should == []

      popped1.should_not equal(popped2)
    end

    it "returns whole elements if n exceeds size of the array" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.shift(6).should == [1, 2, 3, 4, 5]
      a.should == []
    end

    it "does not return self even when it returns whole elements" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.shift(5).should_not equal(a)

      a = @subject.new([1, 2, 3, 4, 5])
      a.shift(6).should_not equal(a)
    end

    it "raises an ArgumentError if n is negative" do
      ->{ @subject.new([1, 2, 3]).shift(-1) }.should raise_error(ArgumentError)
    end

    it "tries to convert n to an Integer using #to_int" do
      a = @subject.new([1, 2, 3, 4])
      a.shift(2.3).should == [1, 2]

      obj = mock('to_int')
      obj.should_receive(:to_int).and_return(2)
      a.should == [3, 4]
      a.shift(obj).should == [3, 4]
      a.should == []
    end

    it "raises a TypeError when the passed n cannot be coerced to Integer" do
      ->{ @subject.new([1, 2]).shift("cat") }.should raise_error(TypeError)
      ->{ @subject.new([1, 2]).shift(nil) }.should raise_error(TypeError)
    end

    it "raises an ArgumentError if more arguments are passed" do
      ->{ @subject.new([1, 2]).shift(1, 2) }.should raise_error(ArgumentError)
    end

    ruby_version_is ''...'2.7' do
      it "returns an untainted array even if the array is tainted" do
        ary = @subject.new([1, 2]).taint
        ary.shift(2).tainted?.should be_false
        ary.shift(0).tainted?.should be_false
      end

      it "keeps taint status" do
        a = @subject.new([1, 2]).taint
        a.shift(2)
        a.tainted?.should be_true
        a.shift(2)
        a.tainted?.should be_true
      end
    end
  end
end

describe "Array#shift" do
  before { @subject =  Array }

  it_behaves_like :collection_shift, :shift

  it "does not return subclass instances with Array subclass" do
    CollectionSpecs::MyArray[1, 2, 3].shift(2).should be_an_instance_of(Array)
  end
end

describe "Collection#shift" do
  before { @subject = Group }

  it_behaves_like :collection_shift, :shift

  it "returns a subclass instances with Array subclass" do
    Group.new([1, 2, 3]).shift(2).should be_an_instance_of(Group)
  end
end