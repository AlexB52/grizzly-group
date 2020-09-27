require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_reverse, shared: true do
  it "returns a new array with the elements in reverse order" do
    @subject.new([]).reverse.should == []
    @subject.new([1, 3, 5, 2]).reverse.should == [2, 5, 3, 1]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.reverse.should == empty

    array = CollectionSpecs.recursive_array(@subject)
    array.reverse.should == [array, array, array, array, array, 3.0, 'two', 1]
  end

  # Todo collectiosn spec change
  # it "does not return subclass instance on Array subclasses" do
  #   CollectionSpecs::MyArray[1, 2, 3].reverse.should be_an_instance_of(Array)
  # end
end

describe :collection_reverse!, shared: true do
  it "reverses the elements in place" do
    a = @subject.new([6, 3, 4, 2, 1])
    a.reverse!.should equal(a)
    a.should == [1, 2, 4, 3, 6]
    @subject.new([]).reverse!.should == []
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.reverse!.should == [empty]

    array = CollectionSpecs.recursive_array(@subject)
    array.reverse!.should == [array, array, array, array, array, 3.0, 'two', 1]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).reverse! }.should raise_error(FrozenError)
  end
end


describe "Array#reverse" do
  before { @subject = Array }

  it_behaves_like :collection_reverse, :reverse

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].reverse.should be_an_instance_of(Array)
  end
end

describe "Collection#reverse" do
  before { @subject = Group }

  it_behaves_like :collection_reverse, :reverse

  it "returns a subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).reverse.should be_an_instance_of(Group)
  end
end

describe "Array#reverse!" do
  before { @subject = Array }

  it_behaves_like :collection_reverse!, :reverse!

  it "returns a subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].reverse!.should be_an_instance_of(CollectionSpecs::MyArray)
  end
end

describe "Collection#reverse!" do
  before { @subject = Group }

  it_behaves_like :collection_reverse!, :reverse!

  it "returns a subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).reverse!.should be_an_instance_of(Group)
  end
end
