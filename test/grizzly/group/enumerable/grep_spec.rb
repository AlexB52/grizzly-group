require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_grep, shared: true do
  # before :each do
  #   @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
  # end

  it "grep without a block should return an array of all elements === pattern" do
    class EnumerableSpecGrep; def ===(obj); obj == '2'; end; end

    EnumerableSpecs::Numerous.new('2', 'a', 'nil', '3', false).grep(EnumerableSpecGrep.new).should == ['2']
  end

  it "grep with a block should return an array of elements === pattern passed through block" do
    class EnumerableSpecGrep2; def ===(obj); /^ca/ =~ obj; end; end

    EnumerableSpecs::Numerous.new("cat", "coat", "car", "cadr", "cost").grep(EnumerableSpecGrep2.new) { |i| i.upcase }.should == ["CAT", "CAR", "CADR"]
  end

  # it "grep the enumerable (rubycon legacy)" do
  #   EnumerableSpecs::EachDefiner.new().grep(1).should == []
  #   @a.grep(3..7).should == [4,6]
  #   @a.grep(3..7) {|a| a+1}.should == [5,7]
  # end

  it "can use $~ in the block when used with a Regexp" do
    ary = @subject.new(["aba", "aba"])
    ary.grep(/a(b)a/) { $1 }.should == ["b", "b"]
  end

  it "sets $~ in the block" do
    "z" =~ /z/ # Reset $~
    @subject.new(["abc", "def"]).grep(/b/) { |e|
      e.should == "abc"
      $&.should == "b"
    }

    # Set by the failed match of "def"
    $~.should == nil
  end

  it "sets $~ to the last match when given no block" do
    "z" =~ /z/ # Reset $~
    @subject.new(["abc", "def"]).grep(/b/).should == ["abc"]

    # Set by the failed match of "def"
    $~.should == nil

    @subject.new(["abc", "def"]).grep(/e/)
    $&.should == "e"
  end

  describe "with a block" do
    before :each do
      @numerous = EnumerableSpecs::Numerous.new(*(0..9).to_a)
      def (@odd_matcher = BasicObject.new).===(obj)
        obj.odd?
      end
    end

    it "returns an Array of matched elements that mapped by the block" do
      @numerous.grep(@odd_matcher) { |n| n * 2 }.should == [2, 6, 10, 14, 18]
    end

    # it "calls the block with gathered array when yielded with multiple arguments" do
    #   EnumerableSpecs::YieldsMixed2.new.grep(Object){ |e| e }.should == EnumerableSpecs::YieldsMixed2.gathered_yields
    # end

    it "raises an ArgumentError when not given a pattern" do
      -> { @numerous.grep { |e| e } }.should raise_error(ArgumentError)
    end
  end
end

describe "Array#grep" do
  before { @subject = Array }

  it_behaves_like :collection_grep, :grep
end

describe "Collection#grep" do
  before { @subject = Group }

  it_behaves_like :collection_grep, :grep

  it "doesn't return a subclass instance on Array subclasses" do
    Group.new([1,2,3,4]).grep(1..2).should be_an_instance_of(Array)
  end
end

