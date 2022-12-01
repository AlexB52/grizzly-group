require_relative '../../spec_helper'

# core/array/shared/clone.rb:2
describe "Array#clone" do
  it "returns a subclass instance" do
    Grizzly::Group.new([]).send(:clone).should be_an_instance_of(Grizzly::Group)
    MyGroup[1, 2].send(:clone).should be_an_instance_of(MyGroup)
  end
end

describe "Array#dup" do
  it "returns a subclass instance" do
    Grizzly::Group.new([]).send(:dup).should be_an_instance_of(Grizzly::Group)
    MyGroup[1, 2].send(:dup).should be_an_instance_of(MyGroup)
  end
end
