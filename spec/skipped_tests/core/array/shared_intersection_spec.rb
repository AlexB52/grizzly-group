require_relative '../../spec_helper'

# core/array/shared/intersection.rb:67
describe "Array#intersection" do
  it "return subclass instances for Array subclasses" do
    MyCollection[1, 2, 3].send(:intersection, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:intersection, MyCollection[1, 2, 3]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([]).send(:intersection, MyCollection[1, 2, 3]).should be_an_instance_of(Grizzly::Collection)
  end
end

describe "Array#&" do
  it "return subclass instances for Array subclasses" do
    MyCollection[1, 2, 3].send(:&, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:&, MyCollection[1, 2, 3]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([]).send(:&, MyCollection[1, 2, 3]).should be_an_instance_of(Grizzly::Collection)
  end
end
