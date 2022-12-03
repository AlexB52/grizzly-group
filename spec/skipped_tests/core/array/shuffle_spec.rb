require_relative '../../spec_helper'

describe "Array#shuffle" do
  # core/array/shuffle_spec.rb:24
  it "returns subclass instances with Array subclass" do
    MyCollection[1, 2, 3].shuffle.should be_an_instance_of(MyCollection)
  end

  # core/array/shuffle_spec.rb:43
  it "accepts a Float for the value returned by #rand" do
    random = mock("array_shuffle_random")
    random.should_receive(:rand).at_least(1).times.and_return(0.3)

    Grizzly::Collection.new([1, 2]).shuffle(random: random).should be_an_instance_of(Grizzly::Collection)
  end

  # core/array/shuffle_spec.rb:50
  it "calls #to_int on the Object returned by #rand" do
    value = mock("array_shuffle_random_value")
    value.should_receive(:to_int).at_least(1).times.and_return(0)
    random = mock("array_shuffle_random")
    random.should_receive(:rand).at_least(1).times.and_return(value)

    Grizzly::Collection.new([1, 2]).shuffle(random: random).should be_an_instance_of(Grizzly::Collection)
  end
end
