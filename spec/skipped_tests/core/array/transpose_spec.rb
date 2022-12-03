require_relative '../../spec_helper'

describe "Array#transpose" do
  # core/array/transpose_spec.rb:47
  it "returns subclass instances if all instances are Grizzly::Collection" do
    result = MyCollection[MyCollection[1, 2, 3], MyCollection[4, 5, 6]].transpose
    result.should be_an_instance_of(MyCollection)
    result[0].should be_an_instance_of(MyCollection)
    result[1].should be_an_instance_of(MyCollection)
  end

  it "returns subclass instance but nested elements are Array if any isn't Grizzly::Collection" do
    result = MyCollection[MyCollection[1, 2, 3], Array[4, 5, 6]].transpose
    result.should be_an_instance_of(MyCollection)
    result[0].should be_an_instance_of(Array)
    result[1].should be_an_instance_of(Array)
  end
end
