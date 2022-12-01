require_relative '../../spec_helper'

describe "Array#plus" do
  # core/array/plus_spec.rb:34
  it "returns subclass instances with Array subclasses" do
    (MyGroup[1, 2, 3] + Grizzly::Group.new([])).should be_an_instance_of(MyGroup)
    (MyGroup[1, 2, 3] + MyGroup[]).should be_an_instance_of(MyGroup)
    (Grizzly::Group.new([1, 2, 3]) + MyGroup[]).should be_an_instance_of(Grizzly::Group)
  end
end
