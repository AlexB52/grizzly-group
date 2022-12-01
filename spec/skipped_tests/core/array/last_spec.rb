require_relative '../../spec_helper'

describe "Array#last" do
  # core/array/last_spec.rb:70
  it "returns subclass instance on Array subclasses" do
    MyGroup[].last(0).should be_an_instance_of(MyGroup)
    MyGroup[].last(2).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].last(0).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].last(1).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].last(2).should be_an_instance_of(MyGroup)
  end
end
