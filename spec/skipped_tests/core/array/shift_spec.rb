require_relative '../../spec_helper'

describe "Array#shift" do
  # core/array/shift_spec.rb:116
  describe "passed a number n as an argument" do
    it "returns subclass instances with Array subclass" do
      MyGroup[1, 2, 3].shift(2).should be_an_instance_of(MyGroup)
    end
  end
end
