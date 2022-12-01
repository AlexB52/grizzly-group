require_relative '../../spec_helper'

describe "Array#partition" do
  # core/array/partition_spec.rb:37
  it "returns subclass instances on Array subclasses" do
    result = MyGroup[1, 2, 3].partition { |x| x % 2 == 0 }
    result.should be_an_instance_of(Array)
    result[0].should be_an_instance_of(MyGroup)
    result[1].should be_an_instance_of(MyGroup)
  end
end
