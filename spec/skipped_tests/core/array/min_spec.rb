require_relative '../../spec_helper'

describe "Array#min" do
  # - core/array/min_spec.rb:4
  it "is defined on Array" do
    Grizzly::Collection.new([1]).method(:min).owner.should equal Grizzly::Enumerable
  end
end
