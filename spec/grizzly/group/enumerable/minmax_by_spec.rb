require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumerable_enumeratorized'

describe :collection_minmax_by, shared: true do
  it "returns an enumerator if no block" do
    @subject.new(EnumerableSpecs::Numerous.new(42)).minmax_by.should be_an_instance_of(Enumerator)
  end

  it "returns nil if #each yields no objects" do
    @subject.new(EnumerableSpecs::Empty.new).minmax_by {|o| o.nonesuch }.should == [nil, nil]
  end

  it "returns the object for whom the value returned by block is the largest" do
    @subject.new(EnumerableSpecs::Numerous.new(*%w[1 2 3])).minmax_by {|obj| obj.to_i }.should == ['1', '3']
    @subject.new(EnumerableSpecs::Numerous.new(*%w[three five])).minmax_by {|obj| obj.length }.should == ['five', 'three']
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c, d = '1', '1', '2', '2'
    mm = @subject.new(EnumerableSpecs::Numerous.new(a, b, c, d)).minmax_by {|obj| obj.to_i }
    mm[0].should equal(a)
    mm[1].should equal(c)
  end

  it "uses min/max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| EnumerableSpecs::ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    @subject.new(EnumerableSpecs::Numerous.new(a, b, c)).minmax_by {|obj| obj }.should == [c, a]
  end

  it "is able to return the maximum for enums that contain nils" do
    enum = @subject.new(EnumerableSpecs::Numerous.new(nil, nil, true))
    enum.minmax_by {|o| o.nil? ? 0 : 1 }.should == [nil, true]
  end

  # it "gathers whole arrays as elements when each yields multiple" do
  #   multi = EnumerableSpecs::YieldsMulti.new
  #   multi.minmax_by {|e| e.size}.should == [[1, 2], [6, 7, 8, 9]]
  # end

  # it_behaves_like :enumerable_enumeratorized_with_origin_size, :minmax_by
end

describe "Array#minmax_by" do
  before { @subject = Array }

  it_behaves_like :enumeratorized_with_origin_size, :minmax_by, [1,2,3,4,5]
end

describe "Collection#minmax_by" do
  before { @subject = Group }

  it_behaves_like :enumeratorized_with_origin_size, :minmax_by, Group.new([1,2,3,4,5])

  it "returns a subclass instance of Array" do
    Group.new([1,2,3,4,5,6]).minmax_by {|a,b| b <=> a }.should be_an_instance_of(Group)
  end
end