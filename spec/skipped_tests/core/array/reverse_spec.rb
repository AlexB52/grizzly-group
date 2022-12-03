require_relative '../../spec_helper'

describe "Array#reverse" do
  # core/array/reverse_spec.rb:18
  it "returns subclass instance on Array subclasses" do
    MyCollection[1, 2, 3].reverse.should be_an_instance_of(MyCollection)
  end
end
