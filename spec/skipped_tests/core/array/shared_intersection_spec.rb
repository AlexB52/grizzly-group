require_relative '../../spec_helper'

# core/array/shared/intersection.rb:67
describe "Array#intersection" do
  it "return subclass instances for Array subclasses" do
    MyGroup[1, 2, 3].send(:intersection, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:intersection, MyGroup[1, 2, 3]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([]).send(:intersection, MyGroup[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#&" do
  it "return subclass instances for Array subclasses" do
    MyGroup[1, 2, 3].send(:&, Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    MyGroup[1, 2, 3].send(:&, MyGroup[1, 2, 3]).should be_an_instance_of(MyGroup)
    Grizzly::Group.new([]).send(:&, MyGroup[1, 2, 3]).should be_an_instance_of(Grizzly::Group)
  end
end
