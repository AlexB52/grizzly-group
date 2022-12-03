require_relative '../../spec_helper'

describe "Array#plus" do
  # core/array/plus_spec.rb:34
  it "returns subclass instances with Array subclasses" do
    (MyCollection[1, 2, 3] + Grizzly::Collection.new([])).should be_an_instance_of(MyCollection)
    (MyCollection[1, 2, 3] + MyCollection[]).should be_an_instance_of(MyCollection)
    (Grizzly::Collection.new([1, 2, 3]) + MyCollection[]).should be_an_instance_of(Grizzly::Collection)
  end
end
