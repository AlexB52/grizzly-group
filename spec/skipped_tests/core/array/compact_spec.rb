require_relative '../../spec_helper'

describe "Array#compact" do
  # core/array/compact_spec.rb:21
  it "returns subclass instance for Array subclasses" do
    MyCollection[1, 2, 3, nil].compact.should be_an_instance_of(MyCollection)
  end
end
