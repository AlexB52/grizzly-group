require_relative '../../spec_helper'

# core/array/shared/difference.rb:33
describe "Array#difference" do
  it "returns subclass instance for Array subclasses" do
    MyCollection[1, 2, 3].send(:difference, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:difference, MyCollection[]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([1, 2, 3]).send(:difference, MyCollection[]).should be_an_instance_of(Grizzly::Collection)
  end
end

describe "Array#-" do
  it "returns subclass instance for Array subclasses" do
    MyCollection[1, 2, 3].send(:-, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:-, MyCollection[]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([1, 2, 3]).send(:-, MyCollection[]).should be_an_instance_of(Grizzly::Collection)
  end
end
