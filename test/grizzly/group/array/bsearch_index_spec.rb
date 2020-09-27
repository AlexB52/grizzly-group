require_relative '../../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe :collection_bsearch_index, shared: true do
  context "when not passed a block" do
    before :each do
      @enum = @subject.new([1, 2, 42, 100, 666]).bsearch_index
    end

    it "returns an Enumerator" do
      @enum.should be_an_instance_of(Enumerator)
    end

    it "returns an Enumerator with unknown size" do
      @enum.size.should be_nil
    end

    it "returns index of element when block condition is satisfied" do
      @enum.each { |x| x >= 33 }.should == 2
    end
  end

  it "raises a TypeError when block returns a String" do
    -> { @subject.new([1, 2, 3]).bsearch_index { "not ok" } }.should raise_error(TypeError)
  end

  it "returns nil when block is empty" do
    @subject.new([1, 2, 3]).bsearch_index {}.should be_nil
  end

  context "minimum mode" do
    before :each do
      @array = @subject.new [0, 4, 7, 10, 12]
    end

    it "returns index of first element which satisfies the block" do
      @array.bsearch_index { |x| x >= 4 }.should == 1
      @array.bsearch_index { |x| x >= 6 }.should == 2
      @array.bsearch_index { |x| x >= -1 }.should == 0
    end

    it "returns nil when block condition is never satisfied" do
      @array.bsearch_index { false }.should be_nil
      @array.bsearch_index { |x| x >= 100 }.should be_nil
    end
  end

  context "find any mode" do
    before :each do
      @array = @subject.new [0, 4, 7, 10, 12]
    end

    it "returns the index of any matched elements where element is between 4 <= x < 8" do
      [1, 2].should include(@array.bsearch_index { |x| 1 - x / 4 })
    end

    it "returns the index of any matched elements where element is between 8 <= x < 10" do
      @array.bsearch_index { |x| 4 - x / 2 }.should be_nil
    end

    it "returns nil when block never returns 0" do
      @array.bsearch_index { |x| 1 }.should be_nil
      @array.bsearch_index { |x| -1 }.should be_nil
    end

    it "returns the middle element when block always returns zero" do
      @array.bsearch_index { |x| 0 }.should == 2
    end

    context "magnitude does not effect the result" do
      it "returns the index of any matched elements where element is between 4n <= xn < 8n" do
        [1, 2].should include(@array.bsearch_index { |x| (1 - x / 4) * (2**100) })
      end

      it "returns nil when block never returns 0" do
        @array.bsearch_index { |x| 1 * (2**100) }.should be_nil
        @array.bsearch_index { |x| (-1) * (2**100) }.should be_nil
      end

      it "handles values from Bignum#coerce" do
        [1, 2].should include(@array.bsearch_index { |x| (2**100).coerce((1 - x / 4) * (2**100)).first })
      end
    end
  end
end

describe "Array#bsearch_index" do
  before { @subject = Array }

  it_behaves_like :collection_bsearch_index, :bsearch_index
end

describe "Collection#bsearch_index" do
  before { @subject = Group }

  it_behaves_like :collection_bsearch_index, :bsearch_index
end