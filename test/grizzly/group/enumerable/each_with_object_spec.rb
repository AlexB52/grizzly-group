require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumerable_enumeratorized'

describe :collection_each_with_object, shared: true do
  before :each do
    @values = [2, 5, 3, 6, 1, 4]
    @enum = @subject.new(EnumerableSpecs::Numerous.new(*@values))
    @initial = "memo"
  end

  it "passes each element and its argument to the block" do
    acc = []
    @enum.each_with_object(@initial) do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  it "returns an enumerator if no block" do
    acc = []
    e = @enum.each_with_object(@initial)
    e.each do |elem, obj|
      obj.should equal(@initial)
      obj = 42
      acc << elem
    end.should equal(@initial)
    acc.should == @values
  end

  # it "gathers whole arrays as elements when each yields multiple" do
  #   multi = EnumerableSpecs::YieldsMulti.new
  #   array = []
  #   multi.each_with_object(array) { |elem, obj| obj << elem }
  #   array.should == [[1, 2], [3, 4, 5], [6, 7, 8, 9]]
  # end

  # it_behaves_like :enumerable_enumeratorized_with_origin_size, [:each_with_object, []]
end

describe "Array#each_with_object" do
  before { @subject = Array }

  it_behaves_like :collection_each_with_object, :each_with_object
  it_behaves_like :enumeratorized_with_origin_size, [:each_with_object, []], [1,2,3,4]
end

describe "Collection#each_with_object" do
  before { @subject = Group }

  it_behaves_like :collection_each_with_object, :each_with_object
  it_behaves_like :enumeratorized_with_origin_size, [:each_with_object, []], Group.new([1,2,3,4])
end