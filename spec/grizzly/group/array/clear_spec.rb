require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_clear, shared: true do
  it "removes all elements" do
    a = @subject.new([1, 2, 3, 4])
    a.clear.should equal(a)
    a.should == []
  end

  it "returns self" do
    a = @subject.new([1])
    a.should equal a.clear
  end

  it "leaves the Array empty" do
    a = @subject.new([1])
    a.clear
    a.empty?.should == true
    a.size.should == 0
  end

  ruby_version_is ''...'2.7' do
    it "keeps tainted status" do
      a = @subject.new([1])
      a.taint
      a.tainted?.should be_true
      a.clear
      a.tainted?.should be_true
    end
  end

  it "does not accept any arguments" do
    -> { @subject.new([1]).clear(true) }.should raise_error(ArgumentError)
  end

  ruby_version_is ''...'2.7' do
    it "keeps untrusted status" do
      a = @subject.new([1])
      a.untrust
      a.untrusted?.should be_true
      a.clear
      a.untrusted?.should be_true
    end
  end

  it "raises a FrozenError on a frozen array" do
    a = @subject.new([1])
    a.freeze
    -> { a.clear }.should raise_error(FrozenError)
  end
end

describe "Array#clear" do
  before { @subject = Array }

  it_behaves_like :collection_clear, :clear
end

describe "Collection#clear" do
  before { @subject = Group }

  it_behaves_like :collection_clear, :clear
end
