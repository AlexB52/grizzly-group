require_relative "../../spec_helper"

describe 'Enumerable#find_all' do
  before :each do
    @elements = (1..10).to_a
    @numerous = Numerous.new(@elements)
    @method = :find_all
  end

  it "returns all elements for which the block is not false" do
    @numerous.send(@method) {|i| i % 3 == 0 }.should ==Numerous.new([3, 6, 9])
    @numerous.send(@method) {|i| true }.should == Numerous.new(@elements)
    @numerous.send(@method) {|i| false }.should == Numerous.new([])
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.send(@method) {|e| e == [3, 4, 5] }.should == YieldsMulti.new([[3, 4, 5]])
  end
end

describe 'Enumerable#select' do
  before :each do
    @elements = (1..10).to_a
    @numerous = Numerous.new(@elements)
    @method = :select
  end

  it "returns all elements for which the block is not false" do
    @numerous.send(@method) {|i| i % 3 == 0 }.should ==Numerous.new([3, 6, 9])
    @numerous.send(@method) {|i| true }.should == Numerous.new(@elements)
    @numerous.send(@method) {|i| false }.should == Numerous.new([])
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.send(@method) {|e| e == [3, 4, 5] }.should == YieldsMulti.new([[3, 4, 5]])
  end
end

describe 'Enumerable#filter' do
  before :each do
    @elements = (1..10).to_a
    @numerous = Numerous.new(@elements)
    @method = :filter
  end

  it "returns all elements for which the block is not false" do
    @numerous.send(@method) {|i| i % 3 == 0 }.should ==Numerous.new([3, 6, 9])
    @numerous.send(@method) {|i| true }.should == Numerous.new(@elements)
    @numerous.send(@method) {|i| false }.should == Numerous.new([])
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.send(@method) {|e| e == [3, 4, 5] }.should == YieldsMulti.new([[3, 4, 5]])
  end
end
