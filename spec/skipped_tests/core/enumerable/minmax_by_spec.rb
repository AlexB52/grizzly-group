require_relative '../../spec_helper'

describe "Enumerable#minmax_by" do
  it "returns nil if #each yields no objects" do
    empty = Grizzly::Collection.new([])
    empty.minmax_by {|o| o.nonesuch }.should == Grizzly::Collection.new([nil, nil])
  end

  it "returns the object for whom the value returned by block is the largest" do
    Grizzly::Collection.new(["1", "2", "3"]).minmax_by {|obj| obj.to_i }.should == ['1', '3']
    Grizzly::Collection.new(["three", "five"]).minmax_by {|obj| obj.length }.should == ['five', 'three']
  end

  it "returns the object that appears first in #each in case of a tie" do
    a, b, c, d = Grizzly::Collection.new(["1", "1", "2", "2"])
    mm = Grizzly::Collection.new([a, b, c, d]).minmax_by {|obj| obj.to_i }
    mm[0].should equal(a)
    mm[1].should equal(c)
  end

  it "uses min/max.<=>(current) to determine order" do
    a, b, c = (1..3).map{|n| ReverseComparable.new(n)}

    # Just using self here to avoid additional complexity
    Grizzly::Collection.new([a, b, c]).minmax_by {|obj| obj }.should == [c, a]
  end

  it "is able to return the maximum for enums that contain nils" do
    enum = Grizzly::Collection.new([nil, nil, true])
    enum.minmax_by {|o| o.nil? ? 0 : 1 }.should == [nil, true]
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.minmax_by {|e| e.size}.should == [Grizzly::Collection.new([1, 2]), Grizzly::Collection.new([6, 7, 8, 9])]
  end

  it "returns an instance of the Enumerable class" do
    result = Grizzly::Collection.new(%w[1, 2, 3, 4, 5]).minmax_by { |obj| obj.to_i }
    result.should be_an_instance_of(Grizzly::Collection)
  end
end
