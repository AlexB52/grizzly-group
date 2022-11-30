require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

# core/array/shared/clone.rb:2
describe "Array#clone" do
  it "returns an Array or a subclass instance" do
    Grizzly::Group.new([]).send(:clone).should be_an_instance_of(Grizzly::Group)
    MyArray[1, 2].send(:clone).should be_an_instance_of(MyArray)
  end
end

describe "Array#dup" do
  it "returns an Array or a subclass instance" do
    Grizzly::Group.new([]).send(:dup).should be_an_instance_of(Grizzly::Group)
    MyArray[1, 2].send(:dup).should be_an_instance_of(MyArray)
  end
end
