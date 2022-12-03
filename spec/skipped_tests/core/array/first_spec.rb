require_relative '../../spec_helper'

describe "Array#first" do
  # core/array/first_spec.rb:76
  it "returns subclass instance when passed count on Array subclasses" do
    MyCollection[].first(0).should be_an_instance_of(MyCollection)
    MyCollection[].first(2).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].first(0).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].first(1).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].first(2).should be_an_instance_of(MyCollection)
  end
end
