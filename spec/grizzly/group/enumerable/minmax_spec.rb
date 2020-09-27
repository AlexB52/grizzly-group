require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_minmax, shared: true do
  before :each do
    @enum = @subject.new(EnumerableSpecs::Numerous.new(6, 4, 5, 10, 8))
    @strs = @subject.new(EnumerableSpecs::Numerous.new("333", "2", "60", "55555", "1010", "111"))
  end

  it "min should return the minimum element" do
    @enum.minmax.should == [4, 10]
    @strs.minmax.should == ["1010", "60" ]
  end

  it "returns [nil, nil] for an empty Enumerable" do
    @subject.new(EnumerableSpecs::Empty.new).minmax.should == [nil, nil]
  end

  it "raises an ArgumentError when elements are incomparable" do
    -> do
      @subject.new(EnumerableSpecs::Numerous.new(11,"22")).minmax
    end.should raise_error(ArgumentError)
    -> do
      @subject.new(EnumerableSpecs::Numerous.new(11,12,22,33)).minmax{|a, b| nil}
    end.should raise_error(ArgumentError)
  end

  it "raises a NoMethodError for elements without #<=>" do
    -> do
      @subject.new(EnumerableSpecs::Numerous.new(BasicObject.new, BasicObject.new)).minmax
    end.should raise_error(NoMethodError)
  end

  it "returns the minimum when using a block rule" do
    @enum.minmax {|a,b| b <=> a }.should == [10, 4]
    @strs.minmax {|a,b| a.length <=> b.length }.should == ["2", "55555"]
  end

  # it "gathers whole arrays as elements when each yields multiple" do
  #   multi = EnumerableSpecs::YieldsMulti.new
  #   multi.minmax.should == [[1, 2], [6, 7, 8, 9]]
  # end
end


describe "Array#minmax" do
  before { @subject = Array }

  it_behaves_like :collection_minmax, :minmax
end

describe "Collection#minmax" do
  before { @subject = Group }

  it_behaves_like :collection_minmax, :minmax

  it "returns a subclass instance of Array" do
    Group.new([1,2,3,4,5,6]).minmax {|a,b| b <=> a }.should be_an_instance_of(Group)
  end
end