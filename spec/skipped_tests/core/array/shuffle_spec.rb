require_relative '../../spec_helper'

describe "Array#shuffle" do
  # core/array/shuffle_spec.rb:24
  it "returns subclass instances with Array subclass" do
    MyCollection[1, 2, 3].shuffle.should be_an_instance_of(MyCollection)
  end
end
