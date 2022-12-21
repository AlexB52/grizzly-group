require_relative '../../spec_helper'

describe "Enumerable#minmax" do
  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.minmax.should == YieldsMulti.new([[1, 2], [6, 7, 8, 9]])
  end
end
