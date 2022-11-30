require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

describe "Array#plus" do
  # core/array/plus_spec.rb:34
  it "does return subclass instances with Array subclasses" do
    (MyArray[1, 2, 3] + Grizzly::Group.new([])).should be_an_instance_of(MyArray)
    (MyArray[1, 2, 3] + MyArray[]).should be_an_instance_of(MyArray)
    (Grizzly::Group.new([1, 2, 3]) + MyArray[]).should be_an_instance_of(Grizzly::Group)
  end
end
