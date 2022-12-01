require_relative '../../spec_helper'

describe "Array.allocate" do
  # core/array/allocate_spec.rb:4
  it "returns an instance of Grizzly::Group" do
    ary = Grizzly::Group.allocate
    ary.should be_an_instance_of(Grizzly::Group)
  end
end
