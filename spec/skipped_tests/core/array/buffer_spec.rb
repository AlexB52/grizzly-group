require_relative '../../spec_helper'

class MyArray < Grizzly::Group; end

describe "Array#plus" do
  # core/array/pack/buffer_spec.rb:26
  it "raises TypeError exception if buffer is not String" do
    -> { Grizzly::Group.new([65]).pack("ccc", buffer: Grizzly::Group.new([])) }.should raise_error(
      TypeError, "buffer must be String, not Grizzly::Group")
  end
end
