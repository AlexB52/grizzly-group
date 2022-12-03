require_relative '../../spec_helper'

describe "Array#zip" do
  # core/array/zip_spec.rb:62
  it "returns nested arrays if one argument isn't a Grizzly::Collection" do
    result = MyCollection[1, 2, 3].zip(Array.new(["a", "b"]))
    result.should be_an_instance_of(Array)
    result.should == [[1, "a"], [2, "b"], [3, nil]]
    result[0].should be_an_instance_of(Array)
    result[1].should be_an_instance_of(Array)
    result[2].should be_an_instance_of(Array)
  end

  class AnotherGroup < Grizzly::Collection; end
  it "returns nested Grizzly::Collection subclass instances when all other arrays aren't of the same type" do
    result = MyCollection[1, 2, 3].zip(AnotherGroup.new(["a", "b"]))
    result.should be_an_instance_of(Array)
    result.should == [[1, "a"], [2, "b"], [3, nil]]
    result[0].should be_an_instance_of(Grizzly::Collection)
    result[1].should be_an_instance_of(Grizzly::Collection)
    result[2].should be_an_instance_of(Grizzly::Collection)
  end

  it "returns nested subclass instances of subclass arguments are all of the same type" do
    result = MyCollection[1, 2, 3].zip(MyCollection["a", "b"])
    result.should be_an_instance_of(Array)
    result.should == [[1, "a"], [2, "b"], [3, nil]]
    result[0].should be_an_instance_of(MyCollection)
    result[1].should be_an_instance_of(MyCollection)
    result[2].should be_an_instance_of(MyCollection)
  end
end
