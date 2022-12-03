require_relative '../../spec_helper'

# core/array/shared/clone.rb:2
describe "Array#clone" do
  it "returns a subclass instance" do
    Grizzly::Collection.new([]).send(:clone).should be_an_instance_of(Grizzly::Collection)
    MyCollection[1, 2].send(:clone).should be_an_instance_of(MyCollection)
  end
end

describe "Array#dup" do
  it "returns a subclass instance" do
    Grizzly::Collection.new([]).send(:dup).should be_an_instance_of(Grizzly::Collection)
    MyCollection[1, 2].send(:dup).should be_an_instance_of(MyCollection)
  end
end
