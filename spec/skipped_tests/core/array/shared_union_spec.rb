require_relative '../../spec_helper'

# core/array/shared/union.rb:62
describe "Array#union" do
  it "returns subclass instances for Array subclasses" do
    MyCollection[1, 2, 3].send(:union, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:union, MyCollection[1, 2, 3]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([]).send(:union, MyCollection[1, 2, 3]).should be_an_instance_of(Grizzly::Collection)
  end
end

describe "Array#|" do
  it "returns subclass instances for Array subclasses" do
    MyCollection[1, 2, 3].send(:|, Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    MyCollection[1, 2, 3].send(:|, MyCollection[1, 2, 3]).should be_an_instance_of(MyCollection)
    Grizzly::Collection.new([]).send(:|, MyCollection[1, 2, 3]).should be_an_instance_of(Grizzly::Collection)
  end
end
