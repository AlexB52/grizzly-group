require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

# core/array/shared/intersection.rb:67
describe "Array#intersection" do
  it "does return subclass instances for Array subclasses" do
    MyArray[1, 2, 3].send(:intersection, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:intersection, MyArray[1, 2, 3]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([]).send(:intersection, MyArray[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#&" do
  it "does return subclass instances for Array subclasses" do
    MyArray[1, 2, 3].send(:&, Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    MyArray[1, 2, 3].send(:&, MyArray[1, 2, 3]).should be_an_instance_of(MyArray)
    Grizzly::Group.new([]).send(:&, MyArray[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end
