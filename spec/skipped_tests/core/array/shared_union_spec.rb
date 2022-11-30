require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

# core/array/shared/union.rb:62
describe "Array#union" do
  it "does not return subclass instances for Array subclasses" do
    MyArray[1, 2, 3].send(:union, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:union, MyArray[1, 2, 3]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([]).send(:union, MyArray[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#|" do
  it "does not return subclass instances for Array subclasses" do
    MyArray[1, 2, 3].send(:|, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:|, MyArray[1, 2, 3]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([]).send(:|, MyArray[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end
