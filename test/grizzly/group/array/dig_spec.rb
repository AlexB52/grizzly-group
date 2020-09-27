require_relative '../../../spec_helper'


describe :collection_dig, shared: true do

  it "returns #at with one arg" do
    @subject.new(['a']).dig(0).should == 'a'
    @subject.new(['a']).dig(1).should be_nil
  end

  it "recurses #{@subject} elements" do
    c = @subject.new [2, '3']
    b = @subject.new [ 1, c ]
    a = @subject.new [ b ]

    a.dig(0, 0).should == 1
    a.dig(0, 1, 1).should == '3'
    a.dig(0, -1, 0).should == 2
  end

  it "returns the nested value specified if the sequence includes a key" do
    a = @subject.new([42, { foo: :bar }])
    a.dig(1, :foo).should == :bar
  end

  it "raises a TypeError for a non-numeric index" do
    -> {
      @subject.new(['a']).dig(:first)
    }.should raise_error(TypeError)
  end

  it "raises a TypeError if any intermediate step does not respond to #dig" do
    a = @subject.new [1, 2]
    -> {
      a.dig(0, 1)
    }.should raise_error(TypeError)
  end

  it "raises an ArgumentError if no arguments provided" do
    -> {
      @subject.new([10]).dig()
    }.should raise_error(ArgumentError)
  end

  it "returns nil if any intermediate step is nil" do
    a = @subject.new [[1, [2, 3]]]
    a.dig(1, 2, 3).should == nil
  end

  it "calls #dig on the result of #at with the remaining arguments" do
    h = @subject.new [[nil, [nil, nil, 42]]]
    h[0].should_receive(:dig).with(1, 2).and_return(42)
    h.dig(0, 1, 2).should == 42
  end

end

describe "Array#dig" do
  before { @subject = Array }

  it_behaves_like :collection_dig, :dig
end

describe "Collection#dig" do
  before { @subject = Group }

  it_behaves_like :collection_dig, :dig
end