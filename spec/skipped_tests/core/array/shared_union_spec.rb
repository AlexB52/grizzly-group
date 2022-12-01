require_relative '../../spec_helper'

# core/array/shared/union.rb:62
describe "Array#union" do
  it "returns subclass instances for Array subclasses" do
    MyGroup[1, 2, 3].send(:union, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:union, MyGroup[1, 2, 3]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([]).send(:union, MyGroup[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#|" do
  it "returns subclass instances for Array subclasses" do
    MyGroup[1, 2, 3].send(:|, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:|, MyGroup[1, 2, 3]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([]).send(:|, MyGroup[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end
