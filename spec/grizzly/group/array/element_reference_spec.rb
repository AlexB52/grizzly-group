require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/slice'

describe :collection_class_reference, shared: true do
  it "[] should return a new array populated with the given elements" do
    array = @subject[1, 'a', nil]
    array[0].should == 1
    array[1].should == 'a'
    array[2].should == nil
  end

  it "when applied to a literal nested array, unpacks its elements into the containing array" do
    @subject[1, 2, *[3, 4, 5]].should == [1, 2, 3, 4, 5]
  end

  it "when applied to a nested referenced array, unpacks its elements into the containing array" do
    splatted_array = @subject[3, 4, 5]
    @subject[1, 2, *splatted_array].should == [1, 2, 3, 4, 5]
  end

  it "can unpack 2 or more nested referenced array" do
    splatted_array = @subject[3, 4, 5]
    splatted_array2 = @subject[6, 7, 8]
    @subject[1, 2, *splatted_array, *splatted_array2].should == [1, 2, 3, 4, 5, 6, 7, 8]
  end

  it "constructs a nested Hash for tailing key-value pairs" do
    @subject[1, 2, 3 => 4, 5 => 6].should == [1, 2, { 3 => 4, 5 => 6 }]
  end

  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear
    end

    it "returns an instance of the subclass" do
      CollectionSpecs::MyArray[1, 2, 3].should be_an_instance_of(CollectionSpecs::MyArray)
    end

    it "does not call #initialize on the subclass instance" do
      CollectionSpecs::MyArray[1, 2, 3].should == [1, 2, 3]
      ScratchPad.recorded.should be_nil
    end
  end
end

describe "Array#[]" do
  before { @subject = Array }

  it_behaves_like :array_slice, :[]
end

describe "Collection#[]" do
  before { @subject = Group }

  it_behaves_like :array_slice, :[]
end

describe "Array.[]" do
  before { @subject = Array }

  it_behaves_like :collection_class_reference, :class_reference
end

describe "Collection.[]" do
  before { @subject = Group }

  it_behaves_like :collection_class_reference, :class_reference
end