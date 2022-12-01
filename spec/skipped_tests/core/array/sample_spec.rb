require_relative '../../spec_helper'

describe "Array#sample" do
  # core/array/sample_spec.rb:36
  it "returns an Array of elements when passed a count" do
    Grizzly::Group.new([1, 2, 3, 4]).sample(3).should be_an_instance_of(Grizzly::Group)
  end

  # core/array/sample_spec.rb:69
  it "does not return subclass instances with Array subclass" do
    MyGroup[1, 2, 3].sample(2).should be_an_instance_of(MyGroup)
  end
end
