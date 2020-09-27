require_relative '../../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'


describe :collection_bsearch, shared: true do
  it "returns an Enumerator when not passed a block" do
    @subject.new([1]).bsearch.should be_an_instance_of(Enumerator)
  end

  it "raises a TypeError if the block returns an Object" do
    -> { @subject.new([1]).bsearch { Object.new } }.should raise_error(TypeError)
  end

  it "raises a TypeError if the block returns a String" do
    -> { @subject.new([1]).bsearch { "1" } }.should raise_error(TypeError)
  end

  context "with a block returning true or false" do
    it "returns nil if the block returns false for every element" do
      @subject.new([0, 1, 2, 3]).bsearch { |x| x > 3 }.should be_nil
    end

    it "returns nil if the block returns nil for every element" do
      @subject.new([0, 1, 2, 3]).bsearch { |x| nil }.should be_nil
    end

    it "returns element at zero if the block returns true for every element" do
      @subject.new([0, 1, 2, 3]).bsearch { |x| x < 4 }.should == 0

    end

    it "returns the element at the smallest index for which block returns true" do
      @subject.new([0, 1, 3, 4]).bsearch { |x| x >= 2 }.should == 3
      @subject.new([0, 1, 3, 4]).bsearch { |x| x >= 1 }.should == 1
    end
  end

  context "with a block returning negative, zero, positive numbers" do
    it "returns nil if the block returns less than zero for every element" do
      @subject.new([0, 1, 2, 3]).bsearch { |x| x <=> 5 }.should be_nil
    end

    it "returns nil if the block returns greater than zero for every element" do
      @subject.new([0, 1, 2, 3]).bsearch { |x| x <=> -1 }.should be_nil

    end

    it "returns nil if the block never returns zero" do
      @subject.new([0, 1, 3, 4]).bsearch { |x| x <=> 2 }.should be_nil
    end

    it "accepts (+/-)Float::INFINITY from the block" do
      @subject.new([0, 1, 3, 4]).bsearch { |x| Float::INFINITY }.should be_nil
      @subject.new([0, 1, 3, 4]).bsearch { |x| -Float::INFINITY }.should be_nil
    end

    it "returns an element at an index for which block returns 0.0" do
      result = @subject.new([0, 1, 2, 3, 4]).bsearch { |x| x < 2 ? 1.0 : x > 2 ? -1.0 : 0.0 }
      result.should == 2
    end

    it "returns an element at an index for which block returns 0" do
      result = @subject.new([0, 1, 2, 3, 4]).bsearch { |x| x < 1 ? 1 : x > 3 ? -1 : 0 }
      [1, 2].should include(result)
    end
  end

  context "with a block that calls break" do
    it "returns nil if break is called without a value" do
      @subject.new(['a', 'b', 'c']).bsearch { |v| break }.should be_nil
    end

    it "returns nil if break is called with a nil value" do
      @subject.new(['a', 'b', 'c']).bsearch { |v| break nil }.should be_nil
    end

    it "returns object if break is called with an object" do
      @subject.new(['a', 'b', 'c']).bsearch { |v| break 1234 }.should == 1234
      @subject.new(['a', 'b', 'c']).bsearch { |v| break 'hi' }.should == 'hi'
      @subject.new(['a', 'b', 'c']).bsearch { |v| break [42] }.should == [42]
    end
  end
end

describe "Array#bsearch" do
  before { @subject = Array }

  it_behaves_like :collection_bsearch, :bsearch
  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, [1,2,3]
end

describe "Collection#bsearch" do
  before { @subject = Group }

  it_behaves_like :collection_bsearch, :bsearch
  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, Group.new([1,2,3])
end