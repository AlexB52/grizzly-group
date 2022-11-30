require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

# core/array/shared/difference.rb:33
describe "Array#difference" do
  it "does not return subclass instance for Array subclasses" do
    MyArray[1, 2, 3].send(:difference, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:difference, MyArray[]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([1, 2, 3]).send(:difference, MyArray[]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#-" do
  it "does not return subclass instance for Array subclasses" do
    MyArray[1, 2, 3].send(:-, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:-, MyArray[]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([1, 2, 3]).send(:-, MyArray[]).should be_an_instance_of(Grizzly::Group)
  end
end
