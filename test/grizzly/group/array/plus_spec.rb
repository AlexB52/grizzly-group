require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collection_plus, shared: true do
  it "concatenates two arrays" do
    (@subject.new([ 1, 2, 3 ]) + [ 3, 4, 5 ]).should == [1, 2, 3, 3, 4, 5]
    (@subject.new([ 1, 2, 3 ]) + []).should == [1, 2, 3]
    (@subject.new([]) + [ 1, 2, 3 ]).should == [1, 2, 3]
    (@subject.new([]) + []).should == []
  end

  it "can concatenate an array with itself" do
    ary = @subject.new([1, 2, 3])
    (ary + ary).should == [1, 2, 3, 1, 2, 3]
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = mock('["x", "y"]')
    obj.should_receive(:to_ary).and_return(["x", "y"])
    (@subject.new([1, 2, 3]) + obj).should == [1, 2, 3, "x", "y"]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    (empty + empty).should == [empty, empty]

    array = CollectionSpecs.recursive_array(@subject)
    (empty + array).should == [empty, 1, 'two', 3.0, array, array, array, array, array]
    (array + array).should == [
      1, 'two', 3.0, array, array, array, array, array,
      1, 'two', 3.0, array, array, array, array, array]
  end

  it "does not call to_ary on array subclasses" do
    ([5, 6] + CollectionSpecs::ToAryArray[1, 2]).should == [5, 6, 1, 2]
  end

  ruby_version_is ''...'2.7' do
    it "does not get infected even if an original array is tainted" do
      (@subject.new([1, 2]) + [3, 4]).tainted?.should be_false
      (@subject.new([1, 2]).taint + [3, 4]).tainted?.should be_false
      (@subject.new([1, 2]) + [3, 4].taint).tainted?.should be_false
      (@subject.new([1, 2]).taint + [3, 4].taint).tainted?.should be_false
    end

    it "does not infected even if an original array is untrusted" do
      (@subject.new([1, 2]) + [3, 4]).untrusted?.should be_false
      (@subject.new([1, 2]).untrust + [3, 4]).untrusted?.should be_false
      (@subject.new([1, 2]) + [3, 4].untrust).untrusted?.should be_false
      (@subject.new([1, 2]).untrust + [3, 4].untrust).untrusted?.should be_false
    end
  end
end

describe "Array#+" do
  before { @subject = Array }

  it_behaves_like :collection_plus, :+

  it "does return subclass instances with Array subclasses" do
    (CollectionSpecs::MyArray[1, 2, 3] + []).should be_an_instance_of(Array)
    (CollectionSpecs::MyArray[1, 2, 3] + CollectionSpecs::MyArray[]).should be_an_instance_of(Array)
    ([1, 2, 3] + CollectionSpecs::MyArray[]).should be_an_instance_of(Array)
  end
end

describe "Collection#+" do
  before { @subject = Group }

  it_behaves_like :collection_plus, :+

  it "does return subclass instances with Array subclasses" do
    (Group.new([1, 2, 3]) + []).should be_an_instance_of(Group)
    (Group.new([1, 2, 3]) + CollectionSpecs::MyArray[]).should be_an_instance_of(Group)
    (Group.new([1, 2, 3]) + CollectionSpecs::MyArray[]).should be_an_instance_of(Group)
  end
end