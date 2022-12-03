require_relative '../../spec_helper'

describe "Array.allocate" do
  # core/array/allocate_spec.rb:4
  it "returns an instance of Grizzly::Collection" do
    ary = Grizzly::Collection.allocate
    ary.should be_an_instance_of(Grizzly::Collection)
  end
end
