require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_transpose, shared: true do
  it "assumes an array of arrays and returns the result of transposing rows and columns" do
    @subject.new([[1, 'a'], [2, 'b'], [3, 'c']]).transpose.should == [[1, 2, 3], ["a", "b", "c"]]
    @subject.new([[1, 2, 3], ["a", "b", "c"]]).transpose.should == [[1, 'a'], [2, 'b'], [3, 'c']]
    @subject.new([]).transpose.should == []
    @subject.new([[]]).transpose.should == []
    @subject.new([[], []]).transpose.should == []
    @subject.new([[0]]).transpose.should == [[0]]
    @subject.new([[0], [1]]).transpose.should == [[0, 1]]
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = mock('[1,2]')
    obj.should_receive(:to_ary).and_return([1, 2])
    @subject.new([obj, [:a, :b]]).transpose.should == [[1, :a], [2, :b]]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.transpose.should == empty

    a = []; a << a
    b = []; b << b
    @subject.new([a, b]).transpose.should == [[a, b]]

    a = [1]; a << a
    b = [2]; b << b
    @subject.new([a, b]).transpose.should == [ [1, 2], [a, b] ]
  end

  it "raises a TypeError if the passed Argument does not respond to #to_ary" do
    -> { @subject.new([Object.new, [:a, :b]]).transpose }.should raise_error(TypeError)
  end

  it "does not call to_ary on array subclass elements" do
    ary = @subject.new([CollectionSpecs::ToAryArray[1, 2], CollectionSpecs::ToAryArray[4, 6]])
    ary.transpose.should == [[1, 4], [2, 6]]
  end

  it "raises an IndexError if the arrays are not of the same length" do
    -> { @subject.new([[1, 2], [:a]]).transpose }.should raise_error(IndexError)
  end

  # New interface
  # it "does not return subclass instance on Array subclasses" do
  #   result = CollectionSpecs::MyArray[CollectionSpecs::MyArray[1, 2, 3], CollectionSpecs::MyArray[4, 5, 6]].transpose
  #   result.should be_an_instance_of(Array)
  #   result[0].should be_an_instance_of(Array)
  #   result[1].should be_an_instance_of(Array)
  # end
end


describe "Array#transpose" do
  before { @subject = Array }

  it_behaves_like :collection_transpose, :transpose

  it "does not return subclass instance on Array subclasses" do
    result = CollectionSpecs::MyArray[CollectionSpecs::MyArray[1, 2, 3], CollectionSpecs::MyArray[4, 5, 6]].transpose
    result.should be_an_instance_of(Array)
    result[0].should be_an_instance_of(Array)
    result[1].should be_an_instance_of(Array)
  end
end

describe "Collection#transpose" do
  before { @subject = Group }

  it_behaves_like :collection_transpose, :transpose

  it "does not return subclass instance on Array subclasses" do
    result = Group.new([
      CollectionSpecs::MyArray[1, 2, 3],
      CollectionSpecs::MyArray[4, 5, 6]
    ]).transpose

    result.should be_an_instance_of(Group) # <- New interface
    result[0].should be_an_instance_of(Array)
    result[1].should be_an_instance_of(Array)
  end
end