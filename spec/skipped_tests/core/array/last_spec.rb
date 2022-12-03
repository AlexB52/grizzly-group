require_relative '../../spec_helper'

describe "Array#last" do
  # core/array/last_spec.rb:70
  it "returns subclass instance on Array subclasses" do
    MyCollection[].last(0).should be_an_instance_of(MyCollection)
    MyCollection[].last(2).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].last(0).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].last(1).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].last(2).should be_an_instance_of(MyCollection)
  end
end
