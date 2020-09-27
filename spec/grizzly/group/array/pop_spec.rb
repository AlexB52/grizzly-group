require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collection_pop, shared: true do
  it "removes and returns the last element of the array" do
    a = @subject.new(["a", 1, nil, true])

    a.pop.should == true
    a.should == ["a", 1, nil]

    a.pop.should == nil
    a.should == ["a", 1]

    a.pop.should == 1
    a.should == ["a"]

    a.pop.should == "a"
    a.should == []
  end

  it "returns nil if there are no more elements" do
    @subject.new([]).pop.should == nil
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.pop.should == []

    array = CollectionSpecs.recursive_array(@subject)
    array.pop.should == [1, 'two', 3.0, array, array, array, array]
  end

  ruby_version_is ''...'2.7' do
    it "keeps taint status" do
      a = @subject.new([1, 2]).taint
      a.pop
      a.tainted?.should be_true
      a.pop
      a.tainted?.should be_true
    end

    it "keeps untrusted status" do
      a = @subject.new([1, 2]).untrust
      a.pop
      a.untrusted?.should be_true
      a.pop
      a.untrusted?.should be_true
    end
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).pop }.should raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).pop }.should raise_error(FrozenError)
  end

  describe "passed a number n as an argument" do
    it "removes and returns an array with the last n elements of the array" do
      a = @subject.new([1, 2, 3, 4, 5, 6])

      a.pop(0).should == []
      a.should == [1, 2, 3, 4, 5, 6]

      a.pop(1).should == [6]
      a.should == [1, 2, 3, 4, 5]

      a.pop(2).should == [4, 5]
      a.should == [1, 2, 3]

      a.pop(3).should == [1, 2, 3]
      a.should == []
    end

    it "returns an array with the last n elements even if shift was invoked" do
      a = @subject.new([1, 2, 3, 4])
      a.shift
      a.pop(3).should == [2, 3, 4]
    end

    it "returns a new empty array if there are no more elements" do
      a = @subject.new([])
      popped1 = a.pop(1)
      popped1.should == []
      a.should == []

      popped2 = a.pop(2)
      popped2.should == []
      a.should == []

      popped1.should_not equal(popped2)
    end

    it "returns whole elements if n exceeds size of the array" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.pop(6).should == [1, 2, 3, 4, 5]
      a.should == []
    end

    it "does not return self even when it returns whole elements" do
      a = @subject.new([1, 2, 3, 4, 5])
      a.pop(5).should_not equal(a)

      a = @subject.new([1, 2, 3, 4, 5])
      a.pop(6).should_not equal(a)
    end

    it "raises an ArgumentError if n is negative" do
      ->{ @subject.new([1, 2, 3]).pop(-1) }.should raise_error(ArgumentError)
    end

    it "tries to convert n to an Integer using #to_int" do
      a = @subject.new([1, 2, 3, 4])
      a.pop(2.3).should == [3, 4]

      obj = mock('to_int')
      obj.should_receive(:to_int).and_return(2)
      a.should == [1, 2]
      a.pop(obj).should == [1, 2]
      a.should == []
    end

    it "raises a TypeError when the passed n cannot be coerced to Integer" do
      ->{ @subject.new([1, 2]).pop("cat") }.should raise_error(TypeError)
      ->{ @subject.new([1, 2]).pop(nil) }.should raise_error(TypeError)
    end

    it "raises an ArgumentError if more arguments are passed" do
      ->{ @subject.new([1, 2]).pop(1, 2) }.should raise_error(ArgumentError)
    end

    it "raises a FrozenError on a frozen array" do
      -> { CollectionSpecs.frozen_array(@subject).pop(2) }.should raise_error(FrozenError)
      -> { CollectionSpecs.frozen_array(@subject).pop(0) }.should raise_error(FrozenError)
    end

    ruby_version_is ''...'2.7' do
      it "returns an untainted array even if the array is tainted" do
        ary = @subject.new([1, 2]).taint
        ary.pop(2).tainted?.should be_false
        ary.pop(0).tainted?.should be_false
      end

      it "keeps taint status" do
        a = @subject.new([1, 2]).taint
        a.pop(2)
        a.tainted?.should be_true
        a.pop(2)
        a.tainted?.should be_true
      end

      it "returns a trusted array even if the array is untrusted" do
        ary = @subject.new([1, 2]).untrust
        ary.pop(2).untrusted?.should be_false
        ary.pop(0).untrusted?.should be_false
      end

      it "keeps untrusted status" do
        a = @subject.new([1, 2]).untrust
        a.pop(2)
        a.untrusted?.should be_true
        a.pop(2)
        a.untrusted?.should be_true
      end
    end
  end
end

describe "Array#pop" do
  before { @subject = Array }

  it_behaves_like :collection_pop, :pop

  it "does not return subclass instances with Array subclass" do
    CollectionSpecs::MyArray[1, 2, 3].pop(2).should be_an_instance_of(Array)
  end
end

describe "Collection#pop" do
  before { @subject = Group }

  it_behaves_like :collection_pop, :pop

  it "returns a subclass instances with Array subclass" do
    Group.new([1, 2, 3]).pop(2).should be_an_instance_of(Group)
  end
end
