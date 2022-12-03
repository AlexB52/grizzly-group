require_relative '../../spec_helper'

describe "Array#pop" do
  describe "passed a number n as an argument" do
    # core/array/pop_spec.rb:115
    it "does not return subclass instances with Array subclass" do
      MyCollection[1, 2, 3].pop(2).should be_an_instance_of(MyCollection)
    end
  end
end
