require_relative '../../spec_helper'

describe "Array#sort" do
  # core/array/sort_spec.rb:167
  it "returns subclass instance on Array subclasses" do
    ary = MyCollection[1, 2, 3]
    ary.sort.should be_an_instance_of(MyCollection)
  end

  # core/array/sort_spec.rb:98
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Collection.new([2, 3, 5, 1, 4])
    a.sort {  1 }.should be_an_instance_of(Grizzly::Collection)
    a.sort {  0 }.should be_an_instance_of(Grizzly::Collection)
    a.sort { -1 }.should be_an_instance_of(Grizzly::Collection)
  end
end
