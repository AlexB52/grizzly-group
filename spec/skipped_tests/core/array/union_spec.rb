require_relative '../../spec_helper'

describe "Array#union" do
  # core/array/union_spec.rb:17
  it "returns subclass instances for Array subclasses" do
    MyCollection[1, 2, 3].union.should be_an_instance_of(MyCollection)
  end
end
