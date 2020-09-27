require_relative '../fixtures/classes'
require_relative 'enumeratorize'
require_relative 'keep_if'
require_relative '../../enumerable/shared/enumeratorized'

describe :array_select, shared: true do
  it_should_behave_like :enumeratorize

  before :each do
    @object = @subject.new([1,2,3])
  end
  it_should_behave_like :enumeratorized_with_origin_size

  it "returns a new array of elements for which block is true" do
    @subject.new([1, 3, 4, 5, 6, 9]).send(@method) { |i| i % ((i + 1) / 2) == 0}.should == [1, 4, 6]
  end

  # !! - This needs to change
  # it "does not return subclass instance on Array subclasses" do
  #   CollectionSpecs::MyArray[1, 2, 3].send(@method) { true }.should be_an_instance_of(Array)
  # end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.send(@method) { true }.should == empty
    empty.send(@method) { false }.should == []

    array = CollectionSpecs.recursive_array(@subject)
    array.send(@method) { true }.should == [1, 'two', 3.0, array, array, array, array, array]
    array.send(@method) { false }.should == []
  end
end
