require_relative '../../spec_helper'

# core/array/shared/select.rb:19
describe "Array#select" do
  it "returns subclass instance on Array subclasses" do
    MyCollection[1, 2, 3].send(:select) { true }.should be_an_instance_of(MyCollection)
  end
end

describe "Array#filter" do
  it "returns subclass instance on Array subclasses" do
    MyCollection[1, 2, 3].send(:filter) { true }.should be_an_instance_of(MyCollection)
  end
end
