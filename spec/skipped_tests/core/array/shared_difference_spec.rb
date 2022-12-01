require_relative '../../spec_helper'

# core/array/shared/difference.rb:33
describe "Array#difference" do
  it "returns subclass instance for Array subclasses" do
    MyGroup[1, 2, 3].send(:difference, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:difference, MyGroup[]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([1, 2, 3]).send(:difference, MyGroup[]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#-" do
  it "returns subclass instance for Array subclasses" do
    MyGroup[1, 2, 3].send(:-, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:-, MyGroup[]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([1, 2, 3]).send(:-, MyGroup[]).should be_an_instance_of(Grizzly::Group)
  end
end
