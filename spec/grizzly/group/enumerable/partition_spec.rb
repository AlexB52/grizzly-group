require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumerable_enumeratorized'

describe :collection_partition, shared: true do
  it "returns two arrays, the first containing elements for which the block is true, the second containing the rest" do
    @subject.new(EnumerableSpecs::Numerous.new).partition { |i| i % 2 == 0 }.should == [[2, 6, 4], [5, 3, 1]]
  end

  it "returns an Enumerator if called without a block" do
    @subject.new(EnumerableSpecs::Numerous.new).partition.should be_an_instance_of(Enumerator)
  end

  # it "gathers whole arrays as elements when each yields multiple" do
  #   multi = EnumerableSpec@::YieldsMulti.new
  #   multi.partition {|e| e == [3, 4, 5] }.should == [[[3, 4, 5]], [[1, 2], [6, 7, 8, 9]]]
  # end

  # it_behaves_like :enumerable_enumeratorized_with_origin_size, :partition
end

describe 'Array#partition' do
  before { @subject = Array }

  it_behaves_like :collection_partition, :partition
  it_behaves_like :enumeratorized_with_origin_size, :partition, [1,2,3,4]

  it "doesn't return subclass instances of Array" do
    truthy, falsy = EnumerableSpecs::MyArray.new(EnumerableSpecs::Numerous.new).partition { |i| i % 2 == 0 }

    truthy.should be_an_instance_of(Array)
    falsy.should be_an_instance_of(Array)
  end
end

describe 'Collection#partition' do
  before { @subject = Group }

  it_behaves_like :collection_partition, :partition
  it_behaves_like :enumeratorized_with_origin_size, :partition, Group.new([1,2,3,4])

  it "returns subclass instances of Array" do
    truthy, falsy = Group.new(EnumerableSpecs::Numerous.new).partition { |i| i % 2 == 0 }

    truthy.should be_an_instance_of(Group)
    falsy.should be_an_instance_of(Group)
  end
end