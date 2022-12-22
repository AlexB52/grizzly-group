require_relative '../../spec_helper'

describe "Array#max" do
  # - core/array/max_spec.rb:4
  it "is defined on Array" do
    Grizzly::Collection.new([1]).method(:max).owner.should equal Grizzly::Enumerable
  end
end
