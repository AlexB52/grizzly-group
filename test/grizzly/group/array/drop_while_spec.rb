require_relative '../../../spec_helper'


describe :collection_drop_while, shared: true do
  it "removes elements from the start of the array while the block evaluates to true" do
    @subject.new([1, 2, 3, 4]).drop_while { |n| n < 4 }.should == [4]
  end

  it "removes elements from the start of the array until the block returns nil" do
    @subject.new([1, 2, 3, nil, 5]).drop_while { |n| n }.should == [nil, 5]
  end

  it "removes elements from the start of the array until the block returns false" do
    @subject.new([1, 2, 3, false, 5]).drop_while { |n| n }.should == [false, 5]
  end
end

describe "Array#drop_while" do
  before { @subject = Array }

  it_behaves_like :collection_drop_while, :drop_while

  it 'returns an instance of a subclass' do
    @subject.new([1,2,3,4,5]).drop_while { false }.should be_an_instance_of(@subject)
  end
end

describe "Collection#drop_while" do
  before { @subject = Group }

  it_behaves_like :collection_drop_while, :drop_while

  it 'returns an instance of a subclass' do
    @subject.new([1,2,3,4,5]).drop_while { false }.should be_an_instance_of(@subject)
  end
end