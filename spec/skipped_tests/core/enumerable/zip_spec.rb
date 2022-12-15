require_relative '../../spec_helper'

# - core/enumerable/zip_spec.rb:6
# - core/enumerable/zip_spec.rb:36
describe "Enumerable#zip" do
  it "combines each element of the receiver with the element of the same index in arrays given as arguments" do
    Numerous.new([1,2,3]).zip([4, 5, 6], [7, 8, 9]).should == [[1, 4, 7],[2, 5, 8],[3, 6, 9]]
    Numerous.new([1,2,3]).zip.should == [Numerous.new([1]), Numerous.new([2]), Numerous.new([3])]
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.zip(multi).should == [
      YieldsMulti.new([[1, 2], [1, 2]]),
      YieldsMulti.new([[3, 4, 5], [3, 4, 5]]),
      YieldsMulti.new([[6, 7, 8, 9], [6, 7, 8, 9]])
    ]
  end
end
