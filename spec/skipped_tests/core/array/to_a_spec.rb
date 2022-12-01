require_relative '../../spec_helper'

class MyWeirdGroup < Grizzly::Group
  def initialize(a, b)
    self << a <<b
  end
end

describe "Array#to_a" do
  # core/array/to_a_spec.rb:5
  it "returns an array" do
    a = Grizzly::Group.new([1, 2, 3])
    a.to_a.should == [1, 2, 3]
    a.to_a.should be_an_instance_of(Array)
  end

  # core/array/to_a_spec.rb:11
  it "does not return subclass instance on Array subclasses" do
    e = MyWeirdGroup.new(1, 2)
    e.to_a.should be_an_instance_of(Array)
    e.to_a.should == [1, 2]
  end
end
