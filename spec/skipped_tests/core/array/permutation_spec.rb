require_relative '../../spec_helper'

describe "Array#permutation" do
  before :each do
    # TODO : Make sure we only need to test the two instance tests for permutation.
    # The full spec is tested because @numbers needed in an update in the before block
    # core/array/permutation_spec.rb:26
    # core/array/permutation_spec.rb:35
    @numbers = Grizzly::Group.new (1..3).to_a
    @yielded = Grizzly::Group.new([])
  end

  it "returns an Enumerator of all permutations when called without a block or arguments" do
    enum = @numbers.permutation
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.sort.should == [
      Grizzly::Group.new([1, 2, 3]),Grizzly::Group.new([1, 3, 2]),Grizzly::Group.new([2, 1, 3]),Grizzly::Group.new([2, 3, 1]),Grizzly::Group.new([3, 1, 2]),Grizzly::Group.new([3, 2, 1])
    ].sort
  end

  it "returns an Enumerator of permutations of given length when called with an argument but no block" do
    enum = @numbers.permutation(1)
    enum.should be_an_instance_of(Enumerator)
    enum.to_a.sort.should == [Grizzly::Group.new([1]),Grizzly::Group.new([2]),Grizzly::Group.new([3])]
  end

  it "yields all permutations to the block then returns self when called with block but no arguments" do
    array = @numbers.permutation {|n| @yielded << n}
    array.should be_an_instance_of(Grizzly::Group)
    array.sort.should == @numbers.sort
    @yielded.sort.should == [
      Grizzly::Group.new([1, 2, 3]),Grizzly::Group.new([1, 3, 2]),Grizzly::Group.new([2, 1, 3]),Grizzly::Group.new([2, 3, 1]),Grizzly::Group.new([3, 1, 2]),Grizzly::Group.new([3, 2, 1])
    ].sort
  end

  it "yields all permutations of given length to the block then returns self when called with block and argument" do
    array = @numbers.permutation(2) {|n| @yielded << n}
    array.should be_an_instance_of(Grizzly::Group)
    array.sort.should == @numbers.sort
    @yielded.sort.should == [Grizzly::Group.new([1, 2]),Grizzly::Group.new([1, 3]),Grizzly::Group.new([2, 1]),Grizzly::Group.new([2, 3]),Grizzly::Group.new([3, 1]),Grizzly::Group.new([3, 2])].sort
  end

  it "returns the empty permutation ([[]]) when the given length is 0" do
    @numbers.permutation(0).to_a.should == [Grizzly::Group.new([])]
    @numbers.permutation(0) { |n| @yielded << n }
    @yielded.should == [Grizzly::Group.new([])]
  end

  it "returns the empty permutation([]) when called on an empty Array" do
    Grizzly::Group.new([]).permutation.to_a.should == [Grizzly::Group.new([])]
    Grizzly::Group.new([]).permutation { |n| @yielded << n }
    @yielded.should == [Grizzly::Group.new([])]
  end

  it "returns no permutations when the given length has no permutations" do
    @numbers.permutation(9).entries.size.should == 0
    @numbers.permutation(9) { |n| @yielded << n }
    @yielded.should == []
  end

  it "handles duplicate elements correctly" do
    @numbers << 1
    @numbers.permutation(2).sort.should == [
      Grizzly::Group.new([1, 1]),Grizzly::Group.new([1, 1]),Grizzly::Group.new([1, 2]),Grizzly::Group.new([1, 2]),Grizzly::Group.new([1, 3]),Grizzly::Group.new([1, 3]),
      Grizzly::Group.new([2, 1]),Grizzly::Group.new([2, 1]),Grizzly::Group.new([2, 3]),
      Grizzly::Group.new([3, 1]),Grizzly::Group.new([3, 1]),Grizzly::Group.new([3, 2])
    ].sort
  end

  it "handles nested Arrays correctly" do
    # The ugliness is due to the order of permutations returned by
    # permutation being undefined combined with #sort croaking on Arrays of
    # Arrays.
    @numbers << Grizzly::Group.new([4, 5])
    got = @numbers.permutation(2).to_a
    expected = [
       Grizzly::Group.new([1, 2]),      Grizzly::Group.new([1, 3]),      [1, Grizzly::Group.new([4, 5])],
       Grizzly::Group.new([2, 1]),      Grizzly::Group.new([2, 3]),      [2, Grizzly::Group.new([4, 5])],
       Grizzly::Group.new([3, 1]),      Grizzly::Group.new([3, 2]),      [3, Grizzly::Group.new([4, 5])],
      [Grizzly::Group.new([4, 5]), 1], [Grizzly::Group.new([4, 5]), 2], [Grizzly::Group.new([4, 5]), 3]
    ]
    expected.each {|e| got.include?(e).should be_true}
    got.size.should == expected.size
  end

  it "truncates Float arguments" do
    @numbers.permutation(3.7).to_a.sort.should ==
      @numbers.permutation(3).to_a.sort
  end

  it "returns an Enumerator which works as expected even when the array was modified" do
    @numbers = Grizzly::Group.new([1, 2])
    enum = @numbers.permutation
    @numbers << 3
    enum.to_a.sort.should == [
      Grizzly::Group.new([1, 2, 3]),Grizzly::Group.new([1, 3, 2]),Grizzly::Group.new([2, 1, 3]),Grizzly::Group.new([2, 3, 1]),Grizzly::Group.new([3, 1, 2]),Grizzly::Group.new([3, 2, 1])
    ].sort
  end

  it "generates from a defensive copy, ignoring mutations" do
    accum = Grizzly::Group.new([])
    ary = Grizzly::Group.new([1, 2, 3])
    ary.permutation(3) do |x|
      accum << x
      ary[0] = 5
    end

    accum.should == [Grizzly::Group.new([1, 2, 3]), Grizzly::Group.new([1, 3, 2]), Grizzly::Group.new([2, 1, 3]), Grizzly::Group.new([2, 3, 1]), Grizzly::Group.new([3, 1, 2]), Grizzly::Group.new([3, 2, 1])]
  end

  describe "when no block is given" do
    describe "returned Enumerator" do
      describe "size" do
        describe "with an array size greater than 0" do
          it "returns the descending factorial of array size and given length" do
            @numbers.permutation(4).size.should == 0
            @numbers.permutation(3).size.should == 6
            @numbers.permutation(2).size.should == 6
            @numbers.permutation(1).size.should == 3
            @numbers.permutation(0).size.should == 1
          end
          it "returns the descending factorial of array size with array size when there's no param" do
            @numbers.permutation.size.should == 6
            Grizzly::Group.new([1, 2, 3, 4]).permutation.size.should == 24
            Grizzly::Group.new([1]).permutation.size.should == 1
          end
        end
        describe "with an empty array" do
          it "returns 1 when the given length is 0" do
            Grizzly::Group.new([]).permutation(0).size.should == 1
          end
          it "returns 1 when there's param" do
            Grizzly::Group.new([]).permutation.size.should == 1
          end
        end
      end
    end
  end
end
