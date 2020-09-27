require_relative '../../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'


describe :collection_cycle, shared: true do
  before :each do
    ScratchPad.record []

    @collection = @subject.new [1, 2, 3]
    @prc = -> x { ScratchPad << x }
  end

  it "does not yield and returns nil when the array is empty and passed value is an integer" do
    @subject.new([]).cycle(6, &@prc).should be_nil
    ScratchPad.recorded.should == []
  end

  it "does not yield and returns nil when the array is empty and passed value is nil" do
    @subject.new([]).cycle(nil, &@prc).should be_nil
    ScratchPad.recorded.should == []
  end

  it "does not yield and returns nil when passed 0" do
    @collection.cycle(0, &@prc).should be_nil
    ScratchPad.recorded.should == []
  end

  it "iterates the array 'count' times yielding each item to the block" do
    @collection.cycle(2, &@prc)
    ScratchPad.recorded.should == [1, 2, 3, 1, 2, 3]
  end

  it "iterates indefinitely when not passed a count" do
    @collection.cycle do |x|
      ScratchPad << x
      break if ScratchPad.recorded.size > 7
    end
    ScratchPad.recorded.should == [1, 2, 3, 1, 2, 3, 1, 2]
  end

  it "iterates indefinitely when passed nil" do
    @collection.cycle(nil) do |x|
      ScratchPad << x
      break if ScratchPad.recorded.size > 7
    end
    ScratchPad.recorded.should == [1, 2, 3, 1, 2, 3, 1, 2]
  end

  it "does not rescue StopIteration when not passed a count" do
    -> do
      @collection.cycle { raise StopIteration }
    end.should raise_error(StopIteration)
  end

  it "does not rescue StopIteration when passed a count" do
    -> do
      @collection.cycle(3) { raise StopIteration }
    end.should raise_error(StopIteration)
  end

  it "iterates the array Integer(count) times when passed a Float count" do
    @collection.cycle(2.7, &@prc)
    ScratchPad.recorded.should == [1, 2, 3, 1, 2, 3]
  end

  it "calls #to_int to convert count to an Integer" do
    count = mock("cycle count 2")
    count.should_receive(:to_int).and_return(2)

    @collection.cycle(count, &@prc)
    ScratchPad.recorded.should == [1, 2, 3, 1, 2, 3]
  end

  it "raises a TypeError if #to_int does not return an Integer" do
    count = mock("cycle count 2")
    count.should_receive(:to_int).and_return("2")

    -> { @collection.cycle(count, &@prc) }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed a String" do
    -> { @collection.cycle("4") { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed an Object" do
    -> { @collection.cycle(mock("cycle count")) { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed true" do
    -> { @collection.cycle(true) { } }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed false" do
    -> { @collection.cycle(false) { } }.should raise_error(TypeError)
  end
end

describe "Array#cycle" do
  before { @subject = Array }

  it_behaves_like :collection_cycle, :cycle

  before :all do
    @object = [1, 2, 3, 4]
    @empty_object = []
  end
  it_should_behave_like :enumeratorized_with_cycle_size
end

describe "Collection#cycle" do
  before { @subject = Group }

  it_behaves_like :collection_cycle, :cycle

  before :all do
    @object = Group.new([1, 2, 3, 4])
    @empty_object = Group.new([])
  end
  it_should_behave_like :enumeratorized_with_cycle_size
end