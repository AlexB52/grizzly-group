require_relative '../../spec_helper'

describe "Array.new" do
  # core/array/new_spec.rb:5
  it "returns an instance of Array" do
    Grizzly::Collection.new.should be_an_instance_of(Grizzly::Collection)
  end
end
