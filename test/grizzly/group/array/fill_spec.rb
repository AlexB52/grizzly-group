require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_fill, shared: true do
  before :all do
    @never_passed = -> i do
      raise ExpectationNotMetError, "the control path should not pass here"
    end
  end

  it "returns self" do
    ary = @subject.new([1, 2, 3])
    ary.fill(:a).should equal(ary)
  end

  it "is destructive" do
    ary = @subject.new([1, 2, 3])
    ary.fill(:a)
    ary.should == [:a, :a, :a]
  end

  it "does not replicate the filler" do
    ary = @subject.new([1, 2, 3, 4])
    str = "x"
    ary.fill(str).should == [str, str, str, str]
    str << "y"
    ary.should == [str, str, str, str]
    ary[0].should equal(str)
    ary[1].should equal(str)
    ary[2].should equal(str)
    ary[3].should equal(str)
  end

  it "replaces all elements in the array with the filler if not given a index nor a length" do
    ary = @subject.new(['a', 'b', 'c', 'duh'])
    ary.fill(8).should == [8, 8, 8, 8]

    str = "x"
    ary.fill(str).should == [str, str, str, str]
  end

  it "replaces all elements with the value of block (index given to block)" do
    @subject.new([nil, nil, nil, nil]).fill { |i| i * 2 }.should == [0, 2, 4, 6]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).fill('x') }.should raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).fill('x') }.should raise_error(FrozenError)
  end

  it "raises an ArgumentError if 4 or more arguments are passed when no block given" do
    -> { @subject.new([]).fill('a') }.should_not raise_error(ArgumentError)

    -> { @subject.new([]).fill('a', 1) }.should_not raise_error(ArgumentError)

    -> { @subject.new([]).fill('a', 1, 2) }.should_not raise_error(ArgumentError)
    -> { @subject.new([]).fill('a', 1, 2, true) }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError if no argument passed and no block given" do
    -> { @subject.new([]).fill }.should raise_error(ArgumentError)
  end

  it "raises an ArgumentError if 3 or more arguments are passed when a block given" do
    -> { @subject.new([]).fill() {|i|} }.should_not raise_error(ArgumentError)

    -> { @subject.new([]).fill(1) {|i|} }.should_not raise_error(ArgumentError)

    -> { @subject.new([]).fill(1, 2) {|i|} }.should_not raise_error(ArgumentError)
    -> { @subject.new([]).fill(1, 2, true) {|i|} }.should raise_error(ArgumentError)
  end
end

describe :collection_fill_filter_index_length, shared: true do
  it "replaces length elements beginning with the index with the filler if given an index and a length" do
    ary = @subject.new([1, 2, 3, 4, 5, 6])
    ary.fill('x', 2, 3).should == [1, 2, 'x', 'x', 'x', 6]
  end

  it "replaces length elements beginning with the index with the value of block" do
    [true, false, true, false, true, false, true].fill(1, 4) { |i| i + 3 }.should == [true, 4, 5, 6, 7, false, true]
  end

  it "replaces all elements after the index if given an index and no length" do
    ary = @subject.new([1, 2, 3])
    ary.fill('x', 1).should == [1, 'x', 'x']
    ary.fill(1){|i| i*2}.should == [1, 2, 4]
  end

  it "replaces all elements after the index if given an index and nil as a length" do
    a = @subject.new([1, 2, 3])
    a.fill('x', 1, nil).should == [1, 'x', 'x']
    a.fill(1, nil){|i| i*2}.should == [1, 2, 4]
    a.fill('y', nil).should == ['y', 'y', 'y']
  end

  it "replaces the last (-n) elements if given an index n which is negative and no length" do
    a = @subject.new([1, 2, 3, 4, 5])
    a.fill('x', -2).should == [1, 2, 3, 'x', 'x']
    a.fill(-2){|i| i.to_s}.should == [1, 2, 3, '3', '4']
  end

  it "replaces the last (-n) elements if given an index n which is negative and nil as a length" do
    a = @subject.new([1, 2, 3, 4, 5])
    a.fill('x', -2, nil).should == [1, 2, 3, 'x', 'x']
    a.fill(-2, nil){|i| i.to_s}.should == [1, 2, 3, '3', '4']
  end

  it "makes no modifications if given an index greater than end and no length" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', 5).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(5, &@never_passed).should == [1, 2, 3, 4, 5]
  end

  it "makes no modifications if given an index greater than end and nil as a length" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', 5, nil).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(5, nil, &@never_passed).should == [1, 2, 3, 4, 5]
  end

  it "replaces length elements beginning with start index if given an index >= 0 and a length >= 0" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', 2, 0).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill('a', 2, 2).should == [1, 2, "a", "a", 5]

    @subject.new([1, 2, 3, 4, 5]).fill(2, 0, &@never_passed).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(2, 2){|i| i*2}.should == [1, 2, 4, 6, 5]
  end

  it "increases the Array size when necessary" do
    a = @subject.new([1, 2, 3])
    a.size.should == 3
    a.fill 'a', 0, 10
    a.size.should == 10
  end

  it "pads between the last element and the index with nil if given an index which is greater than size of the array" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', 8, 5).should == [1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a']
    @subject.new([1, 2, 3, 4, 5]).fill(8, 5){|i| 'a'}.should == [1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a']
  end

  it "replaces length elements beginning with the (-n)th if given an index n < 0 and a length > 0" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', -2, 2).should == [1, 2, 3, "a", "a"]
    @subject.new([1, 2, 3, 4, 5]).fill('a', -2, 4).should == [1, 2, 3, "a", "a", "a", "a"]

    @subject.new([1, 2, 3, 4, 5]).fill(-2, 2){|i| 'a'}.should == [1, 2, 3, "a", "a"]
    @subject.new([1, 2, 3, 4, 5]).fill(-2, 4){|i| 'a'}.should == [1, 2, 3, "a", "a", "a", "a"]
  end

  it "starts at 0 if the negative index is before the start of the array" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', -25, 3).should == ['a', 'a', 'a', 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill('a', -10, 10).should == %w|a a a a a a a a a a|

    @subject.new([1, 2, 3, 4, 5]).fill(-25, 3){|i| 'a'}.should == ['a', 'a', 'a', 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(-10, 10){|i| 'a'}.should == %w|a a a a a a a a a a|
  end

  it "makes no modifications if the given length <= 0" do
    @subject.new([1, 2, 3, 4, 5]).fill('a', 2, 0).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill('a', -2, 0).should == [1, 2, 3, 4, 5]

    @subject.new([1, 2, 3, 4, 5]).fill('a', 2, -2).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill('a', -2, -2).should == [1, 2, 3, 4, 5]

    @subject.new([1, 2, 3, 4, 5]).fill(2, 0, &@never_passed).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(-2, 0, &@never_passed).should == [1, 2, 3, 4, 5]

    @subject.new([1, 2, 3, 4, 5]).fill(2, -2, &@never_passed).should == [1, 2, 3, 4, 5]
    @subject.new([1, 2, 3, 4, 5]).fill(-2, -2, &@never_passed).should == [1, 2, 3, 4, 5]
  end

  # See: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/17481
  it "does not raise an exception if the given length is negative and its absolute value does not exceed the index" do
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -1)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -2)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -3)}.should_not raise_error(ArgumentError)

    -> { @subject.new([1, 2, 3, 4]).fill(3, -1, &@never_passed)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill(3, -2, &@never_passed)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill(3, -3, &@never_passed)}.should_not raise_error(ArgumentError)
  end

  it "does not raise an exception even if the given length is negative and its absolute value exceeds the index" do
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -4)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -5)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill('a', 3, -10000)}.should_not raise_error(ArgumentError)

    -> { @subject.new([1, 2, 3, 4]).fill(3, -4, &@never_passed)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill(3, -5, &@never_passed)}.should_not raise_error(ArgumentError)
    -> { @subject.new([1, 2, 3, 4]).fill(3, -10000, &@never_passed)}.should_not raise_error(ArgumentError)
  end

  it "tries to convert the second and third arguments to Integers using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(2, 2)
    filler = mock('filler')
    filler.should_not_receive(:to_int)
    @subject.new([1, 2, 3, 4, 5]).fill(filler, obj, obj).should == [1, 2, filler, filler, 5]
  end

  it "raises a TypeError if the index is not numeric" do
    -> { @subject.new([]).fill 'a', true }.should raise_error(TypeError)

    obj = mock('nonnumeric')
    -> { @subject.new([]).fill('a', obj) }.should raise_error(TypeError)
  end

  not_supported_on :opal do
    it "raises an ArgumentError or RangeError for too-large sizes" do
      arr = @subject.new([1, 2, 3])
      -> { arr.fill(10, 1, fixnum_max) }.should raise_error(ArgumentError)
      -> { arr.fill(10, 1, bignum_value) }.should raise_error(RangeError)
    end
  end
end

describe :collection_fill_filler_range, shared: true do
  it "replaces elements in range with object" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill(8, 0..3).should == [8, 8, 8, 8, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(8, 0...3).should == [8, 8, 8, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 4..6).should == [1, 2, 3, 4, 'x', 'x', 'x']
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 4...6).should == [1, 2, 3, 4, 'x', 'x']
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2..-1).should == [1, 2, 3, 4, 'x', 'x']
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2...-1).should == [1, 2, 3, 4, 'x', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2...-2).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2..-2).should == [1, 2, 3, 4, 'x', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2..0).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 0...0).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 1..1).should == [1, 'x', 3, 4, 5, 6]
  end

  it "replaces all elements in range with the value of block" do
    @subject.new([1, 1, 1, 1, 1, 1]).fill(1..6) { |i| i + 1 }.should == [1, 2, 3, 4, 5, 6, 7]
  end

  it "increases the Array size when necessary" do
    @subject.new([1, 2, 3]).fill('x', 1..6).should == [1, 'x', 'x', 'x', 'x', 'x', 'x']
    @subject.new([1, 2, 3]).fill(1..6){|i| i+1}.should == [1, 2, 3, 4, 5, 6, 7]
  end

  it "raises a TypeError with range and length argument" do
    -> { @subject.new([]).fill('x', 0 .. 2, 5) }.should raise_error(TypeError)
  end

  it "replaces elements between the (-m)th to the last and the (n+1)th from the first if given an range m..n where m < 0 and n >= 0" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4..4).should == [1, 2, 'x', 'x', 'x', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4...4).should == [1, 2, 'x', 'x', 5, 6]

    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4..4){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4...4){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]
  end

  it "replaces elements between the (-m)th and (-n)th to the last if given an range m..n where m < 0 and n < 0" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4..-2).should == [1, 2, 'x', 'x', 'x', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4...-2).should == [1, 2, 'x', 'x', 5, 6]

    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4..-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4...-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]
  end

  it "replaces elements between the (m+1)th from the first and (-n)th to the last if given an range m..n where m >= 0 and n < 0" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2..-2).should == [1, 2, 'x', 'x', 'x', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2...-2).should == [1, 2, 'x', 'x', 5, 6]

    @subject.new([1, 2, 3, 4, 5, 6]).fill(2..-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', '5', 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(2...-2){|i| (i+1).to_s}.should == [1, 2, '3', '4', 5, 6]
  end

  it "makes no modifications if given an range which implies a section of zero width" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2...2).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4...2).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4...-4).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2...-4).should == [1, 2, 3, 4, 5, 6]

    @subject.new([1, 2, 3, 4, 5, 6]).fill(2...2, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4...2, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4...-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(2...-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]
  end

  it "makes no modifications if given an range which implies a section of negative width" do
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2..1).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -4..1).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', -2..-4).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill('x', 2..-5).should == [1, 2, 3, 4, 5, 6]

    @subject.new([1, 2, 3, 4, 5, 6]).fill(2..1, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-4..1, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(-2..-4, &@never_passed).should == [1, 2, 3, 4, 5, 6]
    @subject.new([1, 2, 3, 4, 5, 6]).fill(2..-5, &@never_passed).should == [1, 2, 3, 4, 5, 6]
  end

  it "raises an exception if some of the given range lies before the first of the array" do
    -> { @subject.new([1, 2, 3]).fill('x', -5..-3) }.should raise_error(RangeError)
    -> { @subject.new([1, 2, 3]).fill('x', -5...-3) }.should raise_error(RangeError)
    -> { @subject.new([1, 2, 3]).fill('x', -5..-4) }.should raise_error(RangeError)

    -> { @subject.new([1, 2, 3]).fill(-5..-3, &@never_passed) }.should raise_error(RangeError)
    -> { @subject.new([1, 2, 3]).fill(-5...-3, &@never_passed) }.should raise_error(RangeError)
    -> { @subject.new([1, 2, 3]).fill(-5..-4, &@never_passed) }.should raise_error(RangeError)
  end

  it "tries to convert the start and end of the passed range to Integers using #to_int" do
    obj = mock('to_int')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    obj.should_receive(:to_int).twice.and_return(2)
    filler = mock('filler')
    filler.should_not_receive(:to_int)
    @subject.new([1, 2, 3, 4, 5]).fill(filler, obj..obj).should == [1, 2, filler, 4, 5]
  end

  it "raises a TypeError if the start or end of the passed range is not numeric" do
    obj = mock('nonnumeric')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    -> { @subject.new([]).fill('a', obj..obj) }.should raise_error(TypeError)
  end

  ruby_version_is "2.6" do
    it "works with endless ranges" do
      @subject.new([1, 2, 3, 4]).fill('x', eval("(1..)")).should == [1, 'x', 'x', 'x']
      @subject.new([1, 2, 3, 4]).fill('x', eval("(3...)")).should == [1, 2, 3, 'x']
      @subject.new([1, 2, 3, 4]).fill(eval("(1..)")) { |x| x + 2 }.should == [1, 3, 4, 5]
      @subject.new([1, 2, 3, 4]).fill(eval("(3...)")) { |x| x + 2 }.should == [1, 2, 3, 5]
    end
  end
end

describe "Array#fill" do
  before { @subject = Array }

  it_behaves_like :collection_fill, :fill
  it_behaves_like :collection_fill_filter_index_length, :fill
  it_behaves_like :collection_fill_filler_range, :fill
end

describe "Collection#fill" do
  before { @subject = Group }

  it_behaves_like :collection_fill, :fill
  it_behaves_like :collection_fill_filter_index_length, :fill
  it_behaves_like :collection_fill_filler_range, :fill

  it "returns a subclass instance of Array" do
    Group.new([]).fill(1).should be_an_instance_of(Group)
  end
end