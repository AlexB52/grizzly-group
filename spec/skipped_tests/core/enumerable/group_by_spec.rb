require_relative '../../spec_helper'

describe "Enumerable#group_by" do
  # core/enumerable/group_by_spec.rb:6
  it "returns a hash with values grouped according to the block" do
    e = Grizzly::Collection.new(["foo", "bar", "baz"])
    h = e.group_by { |word| word[0..0].to_sym }
    h.should == { f: Grizzly::Collection.new(["foo"]), b: Grizzly::Collection.new(["bar", "baz"])}
  end

  # core/enumerable/group_by_spec.rb:28
  it "gathers whole arrays as elements when each yields multiple" do
    e = YieldsMulti.new
    h = e.group_by { |i| i }
    h.should == { [1, 2] => YieldsMulti.new([[1, 2]]),
                  [6, 7, 8, 9] => YieldsMulti.new([[6, 7, 8, 9]]),
                  [3, 4, 5] => YieldsMulti.new([[3, 4, 5]])}
  end
end
