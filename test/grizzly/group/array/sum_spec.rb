require_relative '../../../spec_helper'


describe :collection_sum, shared: true  do
  it "returns the sum of elements" do
    @subject.new([1, 2, 3]).sum.should == 6
  end

  it "applies a block to each element before adding if it's given" do
    @subject.new([1, 2, 3]).sum { |i| i * 10 }.should == 60
  end

  it "returns init value if array is empty" do
    @subject.new([]).sum(-1).should == -1
  end

  it "returns 0 if array is empty and init is omitted" do
    @subject.new([]).sum.should == 0
  end

  it "adds init value to the sum of elements" do
    @subject.new([1, 2, 3]).sum(10).should == 16
  end

  it "can be used for non-numeric objects by providing init value" do
    @subject.new(["a", "b", "c"]).sum("").should == "abc"
  end

  it 'raises TypeError if any element are not numeric' do
    -> { @subject.new(["a"]).sum }.should raise_error(TypeError)
  end

  it 'raises TypeError if any element cannot be added to init value' do
    -> { @subject.new([1]).sum([]) }.should raise_error(TypeError)
  end

  it "calls + to sum the elements" do
    a = mock("a")
    b = mock("b")
    a.should_receive(:+).with(b).and_return(42)
    @subject.new([b]).sum(a).should == 42
  end
end

describe "Array#sum" do
  before { @subject = Array }

  it_behaves_like :collection_sum, :sum
end

describe "Collection#sum" do
  before { @subject = Group }

  it_behaves_like :collection_sum, :sum
end