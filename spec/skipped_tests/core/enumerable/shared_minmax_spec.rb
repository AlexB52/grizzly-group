require_relative "../../spec_helper"

describe :enumerable_minmax, shared: true do
  it "returns an instance of subclass" do
    @enum.minmax.should be_an_instance_of(Numerous)
  end

  # - shared/enumerable/minmax.rb:2
  # - shared/enumerable/minmax.rb:7
  # - shared/enumerable/minmax.rb:12
  it "min should return the minimum element" do
    @enum.minmax.should == Numerous.new([4, 10])
    @strs.minmax.should == Numerous.new(["1010", "60"])
  end

  it "returns the minimum when using a block rule" do
    @enum.minmax {|a,b| b <=> a }.should == Numerous.new([10, 4])
    @strs.minmax {|a,b| a.length <=> b.length }.should == Numerous.new(["2", "55555"])
  end

  it "returns [nil, nil] for an empty Enumerable" do
    @empty_enum.minmax.should == [nil, nil]
  end
end

describe 'Enumerable#minmax' do
  before :each do
    @enum = Numerous.new([6, 4, 5, 10, 8])
    @empty_enum = Grizzly::Collection.new([])
    @incomparable_enum = Numerous.new([BasicObject.new, BasicObject.new])
    @incompatible_enum = Numerous.new([11,"22"])
    @strs = Numerous.new(["333", "2", "60", "55555", "1010", "111"])
  end

  it_behaves_like :enumerable_minmax, :minmax
end