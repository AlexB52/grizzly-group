require_relative '../../spec_helper'

describe "Array#values_at" do
  # core/array/values_at_spec.rb:60
  it "returns subclass instance on Array subclasses" do
    MyCollection[1, 2, 3].values_at(0, 1..2, 1).should be_an_instance_of(MyCollection)
  end
end
