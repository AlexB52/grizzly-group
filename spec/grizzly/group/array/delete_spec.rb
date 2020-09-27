require_relative '../../../spec_helper'


describe :collection_delete, shared: true do
  it "removes elements that are #== to object" do
    x = mock('delete')
    def x.==(other) 3 == other end

    a = @subject.new([1, 2, 3, x, 4, 3, 5, x])
    a.delete mock('not contained')
    a.should == [1, 2, 3, x, 4, 3, 5, x]

    a.delete 3
    a.should == [1, 2, 4, 5]
  end

  it "calculates equality correctly for reference values" do
    a = @subject.new(["foo", "bar", "foo", "quux", "foo"])
    a.delete "foo"
    a.should == ["bar","quux"]
  end

  it "returns object or nil if no elements match object" do
    @subject.new([1, 2, 4, 5]).delete(1).should == 1
    @subject.new([1, 2, 4, 5]).delete(3).should == nil
  end

  it "may be given a block that is executed if no element matches object" do
    @subject.new([1]).delete(1) {:not_found}.should == 1
    @subject.new([]).delete('a') {:not_found}.should == :not_found
  end

  it "returns nil if the array is empty due to a shift" do
    a = @subject.new([1])
    a.shift
    a.delete(nil).should == nil
  end

  it "returns nil on a frozen array if a modification does not take place" do
    @subject.new([1, 2, 3]).freeze.delete(0).should == nil
  end

  it "raises a FrozenError on a frozen array" do
    -> { @subject.new([1, 2, 3]).freeze.delete(1) }.should raise_error(FrozenError)
  end

  ruby_version_is ''...'2.7' do
    it "keeps tainted status" do
      a = @subject.new([1, 2])
      a.taint
      a.tainted?.should be_true
      a.delete(2)
      a.tainted?.should be_true
      a.delete(1) # now empty
      a.tainted?.should be_true
    end

    it "keeps untrusted status" do
      a = @subject.new([1, 2])
      a.untrust
      a.untrusted?.should be_true
      a.delete(2)
      a.untrusted?.should be_true
      a.delete(1) # now empty
      a.untrusted?.should be_true
    end
  end
end

describe "Array#delete" do
  before { @subject = Array }

  it_behaves_like :collection_delete, :delete

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete(4)
    a.should be_an_instance_of(@subject)
  end
end

describe "Collection#delete" do
  before { @subject = Group }

  it_behaves_like :collection_delete, :delete

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete(4)
    a.should be_an_instance_of(@subject)
  end
end