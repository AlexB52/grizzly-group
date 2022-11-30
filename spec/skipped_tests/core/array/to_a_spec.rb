require_relative '../../spec_helper'

describe "Array#to_a" do
  # core/array/to_a_spec.rb:5
  it "returns an array" do
    a = Grizzly::Group.new([1, 2, 3])
    a.to_a.should == [1, 2, 3]
    a.to_a.should be_an_instance_of(Array)
  end
end
