require_relative '../../spec_helper'

describe "Array#sample" do
  # core/array/sample_spec.rb:69
  it "returns subclass instances with Array subclass" do
    MyCollection[1, 2, 3].sample(2).should be_an_instance_of(MyCollection)
  end
end
