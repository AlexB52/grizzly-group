require_relative '../../spec_helper'

describe "Array#sample" do
  # core/array/sample_spec.rb:36
  it "returns an Array of elements when passed a count" do
    Grizzly::Collection.new([1, 2, 3, 4]).sample(3).should be_an_instance_of(Grizzly::Collection)
  end

  # core/array/sample_spec.rb:69
  it "does not return subclass instances with Array subclass" do
    MyCollection[1, 2, 3].sample(2).should be_an_instance_of(MyCollection)
  end
end
