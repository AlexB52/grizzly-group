require_relative '../../../spec_helper'
require_relative 'shared/eql'


describe :collection_equal_value, shared: true do
  it "compares with an equivalent Array-like object using #to_ary" do
    obj = mock('array-like')
    obj.should_receive(:respond_to?).at_least(1).with(:to_ary).and_return(true)
    obj.should_receive(:==).with([1]).at_least(1).and_return(true)

    (@subject.new([1]) == obj).should be_true
    (@subject.new([[1]]) == [obj]).should be_true
    (@subject.new([[[1], 3], 2]) == [[obj, 3], 2]).should be_true

    # recursive arrays
    arr1 = @subject.new([[1]])
    arr1 << arr1
    arr2 = @subject.new([obj])
    arr2 << arr2
    (arr1 == arr2).should be_true
    (arr2 == arr1).should be_true
  end

  it "returns false if any corresponding elements are not #==" do
    a = @subject.new(["a", "b", "c"])
    b = @subject.new(["a", "b", "not equal value"])
    a.should_not == b

    c = mock("c")
    c.should_receive(:==).and_return(false)
    @subject.new(["a", "b", c]).should_not == a
  end

  it "returns true if corresponding elements are #==" do
    @subject.new([]).should == []
    @subject.new(["a", "c", 7]).should == ["a", "c", 7]

    @subject.new([1, 2, 3]).should == [1.0, 2.0, 3.0]

    obj = mock('5')
    obj.should_receive(:==).and_return(true)
    @subject.new([obj]).should == [5]
  end

  # See https://bugs.ruby-lang.org/issues/1720
  it "returns true for [NaN] == [NaN] because Array#== first checks with #equal? and NaN.equal?(NaN) is true" do
    @subject.new([Float::NAN]).should == [Float::NAN]
  end
end

describe "Array#==" do
  before { @subject = Array }

  it_behaves_like :array_eql, :==
  it_behaves_like :collection_equal_value, :==
end

describe "Collection#==" do
  before { @subject = Group }

  it_behaves_like :array_eql, :==
  it_behaves_like :collection_equal_value, :==
end

