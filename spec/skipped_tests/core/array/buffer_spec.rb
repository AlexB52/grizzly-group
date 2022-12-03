require_relative '../../spec_helper'

describe "Array#plus" do
  # core/array/pack/buffer_spec.rb:26
  it "raises TypeError exception if buffer is not String" do
    -> { Grizzly::Collection.new([65]).pack("ccc", buffer: Grizzly::Collection.new([])) }.should raise_error(
      TypeError, "buffer must be String, not Grizzly::Collection")
  end
end
