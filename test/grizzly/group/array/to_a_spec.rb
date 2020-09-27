require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collection_to_a, shared: true do
  it "does not return subclass instance on Array subclasses" do
    #TODO: Investigate subclassing
    e = CollectionSpecs::MyArray.new(1, 2)
    e.to_a.should be_an_instance_of(Array)
    e.to_a.should == [1, 2]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.to_a.should == empty

    array = CollectionSpecs.recursive_array(@subject)
    array.to_a.should == array
  end
end

describe "Array#to_a" do
  before { @subject =  Array }

  it_behaves_like :collection_to_a, :to_a

  it "returns self" do
    a = [1, 2, 3]
    a.to_a.should == [1, 2, 3]
    a.should equal(a.to_a)
  end
end

describe "Collection#to_a" do
  before { @subject = Group }

  it_behaves_like :collection_to_a, :to_a

  it "does not return self" do
    a = Group.new([1, 2, 3])
    a.to_a.should == [1, 2, 3]
    a.should_not equal(a.to_a)
  end
end