require_relative '../../spec_helper'

describe "Array#sort" do
  # core/array/sort_spec.rb:98
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Group.new([2, 3, 5, 1, 4])
    a.sort {  1 }.should be_an_instance_of(Grizzly::Group)
    a.sort {  0 }.should be_an_instance_of(Grizzly::Group)
    a.sort { -1 }.should be_an_instance_of(Grizzly::Group)
  end

  it "returns subclass instance on Array subclasses" do
    ary = MyGroup[1, 2, 3]
    ary.sort.should be_an_instance_of(MyGroup)
  end
end

describe "Array#sort!" do
  # core/array/sort_spec.rb:229
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Group.new([2, 3, 5, 1, 4])
    a.sort!{  1 }.should be_an_instance_of(Grizzly::Group)
    a.sort!{  0 }.should be_an_instance_of(Grizzly::Group)
    a.sort!{ -1 }.should be_an_instance_of(Grizzly::Group)
  end
end