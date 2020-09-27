require_relative '../../../spec_helper'


describe :collection_delete_at, shared: true do
  it "removes the element at the specified index" do
    a = @subject.new([1, 2, 3, 4])
    a.delete_at(2)
    a.should == [1, 2, 4]
    a.delete_at(-1)
    a.should == [1, 2]
  end

  it "returns the removed element at the specified index" do
    a = @subject.new([1, 2, 3, 4])
    a.delete_at(2).should == 3
    a.delete_at(-1).should == 4
  end

  it "returns nil and makes no modification if the index is out of range" do
    a = @subject.new([1, 2])
    a.delete_at(3).should == nil
    a.should == [1, 2]
    a.delete_at(-3).should == nil
    a.should == [1, 2]
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(-1)
    @subject.new([1, 2]).delete_at(obj).should == 2
  end

  it "accepts negative indices" do
    a = @subject.new([1, 2])
    a.delete_at(-2).should == 1
  end

  it "raises a FrozenError on a frozen array" do
    -> { @subject.new([1,2,3]).freeze.delete_at(0) }.should raise_error(FrozenError)
  end

  ruby_version_is ''...'2.7' do
    it "keeps tainted status" do
      ary = @subject.new([1, 2])
      ary.taint
      ary.tainted?.should be_true
      ary.delete_at(0)
      ary.tainted?.should be_true
      ary.delete_at(0) # now empty
      ary.tainted?.should be_true
    end

    it "keeps untrusted status" do
      ary = @subject.new([1, 2])
      ary.untrust
      ary.untrusted?.should be_true
      ary.delete_at(0)
      ary.untrusted?.should be_true
      ary.delete_at(0) # now empty
      ary.untrusted?.should be_true
    end
  end
end

describe "Array#delete_at" do
  before { @subject =  Array }

  it_behaves_like :collection_delete_at, :delete_at

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete_at(0)
    a.should be_an_instance_of(@subject)
  end
end

describe "Collection#delete_at" do
  before { @subject = Group }

  it_behaves_like :collection_delete_at, :delete_at

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete_at(0)
    a.should be_an_instance_of(@subject)
  end
end