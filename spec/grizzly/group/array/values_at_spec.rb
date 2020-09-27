require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_values_at, shared: true do
  it "returns an array of elements at the indexes when passed indexes" do
    @subject.new([1, 2, 3, 4, 5]).values_at().should == []
    @subject.new([1, 2, 3, 4, 5]).values_at(1, 0, 5, -1, -8, 10).should == [2, 1, nil, 5, nil, nil]
  end

  it "calls to_int on its indices" do
    obj = mock('1')
    def obj.to_int() 1 end
    @subject.new([1, 2]).values_at(obj, obj, obj).should == [2, 2, 2]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.values_at(0, 1, 2).should == [empty, nil, nil]

    array = CollectionSpecs.recursive_array(@subject)
    array.values_at(0, 1, 2, 3).should == [1, 'two', 3.0, array]
  end

  describe "when passed ranges" do
    it "returns an array of elements in the ranges" do
      @subject.new([1, 2, 3, 4, 5]).values_at(0..2, 1...3, 2..-2).should == [1, 2, 3, 2, 3, 3, 4]
      @subject.new([1, 2, 3, 4, 5]).values_at(6..4).should == []
    end

    it "calls to_int on arguments of ranges" do
      from = mock('from')
      to = mock('to')

      # So we can construct a range out of them...
      def from.<=>(o) 0 end
      def to.<=>(o) 0 end

      def from.to_int() 1 end
      def to.to_int() -2 end

      ary = @subject.new [1, 2, 3, 4, 5]
      ary.values_at(from .. to, from ... to, to .. from).should == [2, 3, 4, 2, 3]
    end
  end

  describe "when passed a range" do
    it "fills with nil if the index is out of the range" do
      @subject.new([0, 1]).values_at(0..3).should == [0, 1, nil, nil]
      @subject.new([0, 1]).values_at(2..4).should == [nil, nil, nil]
    end

    describe "on an empty array" do
      it "fills with nils if the index is out of the range" do
        @subject.new([]).values_at(0..2).should == [nil, nil, nil]
        @subject.new([]).values_at(1..3).should == [nil, nil, nil]
      end
    end
  end

  ruby_version_is "2.6" do
    it "works when given endless ranges" do
      @subject.new([1, 2, 3, 4]).values_at(eval("(1..)")).should == [2, 3, 4]
      @subject.new([1, 2, 3, 4]).values_at(eval("(3...)")).should == [4]
    end
  end
end

describe "Array#values_at" do
  before { @subject = Array }

  it_behaves_like :collection_values_at, :values_at

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].values_at(0, 1..2, 1).should be_an_instance_of(Array)
  end
end
describe "Collection#values_at" do
  before { @subject = Group }

  it_behaves_like :collection_values_at, :values_at

  it "returns a subclass instance on Array subclasses" do
    @subject.new(CollectionSpecs::MyArray[1, 2, 3]).values_at(0, 1..2, 1).should be_an_instance_of(Group)
  end
end