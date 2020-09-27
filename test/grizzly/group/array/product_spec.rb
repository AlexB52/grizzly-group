require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_product, shared: true do
  it "returns converted arguments using :to_ary" do
    ->{ @subject.new([1]).product(2..3) }.should raise_error(TypeError)
    ar = CollectionSpecs::ArrayConvertible.new(2,3)
    @subject.new([1]).product(ar).should == [[1,2],[1,3]]
    ar.called.should == :to_ary
  end

  it "returns the expected result" do
    @subject.new([1,2]).product([3,4,5],[6,8]).should == [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                                            [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]
  end

  it "has no required argument" do
    @subject.new([1,2]).product.should == [[1],[2]]
  end

  it "returns an empty array when the argument is an empty array" do
    @subject.new([1, 2]).product([]).should == []
  end

  it "does not attempt to produce an unreasonable number of products" do
    a = @subject.new((0..100).to_a)
    -> do
      a.product(a, a, a, a, a, a, a, a, a, a)
    end.should raise_error(RangeError)
  end

  describe "when given a block" do
    it "yields all combinations in turn" do
      acc = []
      @subject.new([1,2]).product([3,4,5],[6,8]){|array| acc << array}
      acc.should == [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                     [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]]

      acc = []
      @subject.new([1,2]).product([3,4,5],[],[6,8]){|array| acc << array}
      acc.should be_empty
    end

    it "returns self" do
      a = @subject.new([1, 2, 3]).freeze

      a.product([1, 2]) { |p| p.first }.should == a
    end

    it "will ignore unreasonable numbers of products and yield anyway" do
      a = @subject.new((0..100).to_a)
      -> do
        a.product(a, a, a, a, a, a, a, a, a, a)
      end.should raise_error(RangeError)
    end
  end

  describe "when given an empty block" do
    it "returns self" do
      arr = @subject.new([1,2])
      arr.product([3,4,5],[6,8]){}.should equal(arr)
      arr = @subject.new([])
      arr.product([3,4,5],[6,8]){}.should equal(arr)
      arr = @subject.new([1,2])
      arr.product([]){}.should equal(arr)
    end
  end
end


describe "Array#product" do
  before { @subject = Array }

  it_behaves_like :collection_product, :product

  it "does not return subclass instance on Array subclasses" do
    result = CollectionSpecs::MyArray[1, 2, 3].product(["a", "b"])

    result.should be_an_instance_of(Array)
    result.first.should be_an_instance_of(Array)
    result.all? { |product| product.is_a?(Array) }.should be_true
  end
end

describe "Collection#product" do
  before { @subject = Group }

  it_behaves_like :collection_product, :product

  it "returns an array of subclass instances on Array subclasses" do
    result = Group.new([1, 2, 3]).product(["a", "b"])

    result.should be_an_instance_of(Array)
    result.first.should be_an_instance_of(Group)
    result.all? { |product| product.is_a?(Group) }.should be_true
  end
end
