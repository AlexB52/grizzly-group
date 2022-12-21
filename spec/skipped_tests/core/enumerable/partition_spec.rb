require_relative '../../spec_helper'

describe "Enumerable#partition" do
  it "returns two arrays, the first containing elements for which the block is true, the second containing the rest" do

    Numerous.new.partition { |i| i % 2 == 0 }.should == [Numerous.new([2, 6, 4]), Numerous.new([5, 3, 1])]
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.partition {|e| e == [3, 4, 5] }.should == [YieldsMulti.new([[3, 4, 5]]), YieldsMulti.new([[1, 2], [6, 7, 8, 9]])]
  end
end
