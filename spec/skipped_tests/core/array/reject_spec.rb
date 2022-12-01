require_relative '../../spec_helper'

describe "Array#reject" do
  # core/array/reject_spec.rb:36
  it "returns subclass instance on Array subclasses" do
    MyGroup[1, 2, 3].reject { |x| x % 2 == 0 }.should be_an_instance_of(MyGroup)
  end
end
