require_relative '../../spec_helper'

describe "Array#sample" do
  # core/array/sample_spec.rb:20
  it "returns nil for an empty array when called without n and a Random is given" do
    Grizzly::Collection.new([]).sample(random: Random.new(42)).should be_nil
  end

  # core/array/sample_spec.rb:28
  it "returns a single value when not passed a count and a Random is given" do
    Grizzly::Collection.new([4]).sample(random: Random.new(42)).should equal(4)
  end

  # core/array/sample_spec.rb:36
  it "returns an Array of elements when passed a count" do
    Grizzly::Collection.new([1, 2, 3, 4]).sample(3).should be_an_instance_of(Grizzly::Collection)
  end

  # core/array/sample_spec.rb:69
  it "does not return subclass instances with Array subclass" do
    MyCollection[1, 2, 3].sample(2).should be_an_instance_of(MyCollection)
  end

  describe "with options" do
    # core/array/sample_spec.rb:74
    it "calls #rand on the Object passed by the :random key in the arguments Hash" do
      obj = mock("array_sample_random")
      obj.should_receive(:rand).and_return(0.5)

      Grizzly::Collection.new([1, 2]).sample(random: obj).should be_an_instance_of(Integer)
    end

    # core/array/sample_spec.rb:81
    it "raises a NoMethodError if an object passed for the RNG does not define #rand" do
      obj = BasicObject.new

      -> { Grizzly::Collection.new([1, 2]).sample(random: obj) }.should raise_error(NoMethodError)
    end

    describe "when the object returned by #rand is an Integer" do
      # core/array/sample_spec.rb:88
      it "uses the integer as index" do
        random = mock("array_sample_random_ret")
        random.should_receive(:rand).and_return(0)

        Grizzly::Collection.new([1, 2]).sample(random: random).should == 1

        random = mock("array_sample_random_ret")
        random.should_receive(:rand).and_return(1)

        Grizzly::Collection.new([1, 2]).sample(random: random).should == 2
      end

      # core/array/sample_spec.rb:100
      it "raises a RangeError if the value is less than zero" do
        random = mock("array_sample_random")
        random.should_receive(:rand).and_return(-1)

        -> { Grizzly::Collection.new([1, 2]).sample(random: random) }.should raise_error(RangeError)
      end

      # core/array/sample_spec.rb:107
      it "raises a RangeError if the value is equal to the Array size" do
        random = mock("array_sample_random")
        random.should_receive(:rand).and_return(2)

        -> { Grizzly::Collection.new([1, 2]).sample(random: random) }.should raise_error(RangeError)
      end
    end

    describe "when the object returned by #rand is not an Integer but responds to #to_int" do
      # core/array/sample_spec.rb:117
      it "calls #to_int on the Object" do
        value = mock("array_sample_random_value")
        value.should_receive(:to_int).and_return(1)
        random = mock("array_sample_random")
        random.should_receive(:rand).and_return(value)

        Grizzly::Collection.new([1, 2]).sample(random: random).should == 2
      end

      # core/array/sample_spec.rb:126
      it "raises a RangeError if the value is less than zero" do
        value = mock("array_sample_random_value")
        value.should_receive(:to_int).and_return(-1)
        random = mock("array_sample_random")
        random.should_receive(:rand).and_return(value)

        -> { Grizzly::Collection.new([1, 2]).sample(random: random) }.should raise_error(RangeError)
      end

      # core/array/sample_spec.rb:135
      it "raises a RangeError if the value is equal to the Array size" do
        value = mock("array_sample_random_value")
        value.should_receive(:to_int).and_return(2)
        random = mock("array_sample_random")
        random.should_receive(:rand).and_return(value)

        -> { Grizzly::Collection.new([1, 2]).sample(random: random) }.should raise_error(RangeError)
      end
    end
  end
end
