require_relative '../../spec_helper'

describe "Enumerable#reject" do
  it "returns an array of the elements for which block is false" do
    Numerous.new.reject { |i| i > 3 }.should == Numerous.new([2, 3, 1])
    entries = (1..10).to_a
    numerous = Numerous.new(entries)
    numerous.reject {|i| i % 2 == 0 }.should == Numerous.new([1,3,5,7,9])
    numerous.reject {|i| true }.should == Numerous.new([])
    numerous.reject {|i| false }.should == Numerous.new(entries)
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.reject {|e| e == [3, 4, 5] }.should == YieldsMulti.new([[1, 2], [6, 7, 8, 9]])
  end
end
