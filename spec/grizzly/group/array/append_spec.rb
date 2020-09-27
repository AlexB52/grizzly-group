require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/push'


describe :collection_push_operator, shared: true do
  it "pushes the object onto the end of the array" do
    (@subject.new([ 1, 2 ]) << "c" << "d" << [ 3, 4 ]).should == [1, 2, "c", "d", [3, 4]]
  end

  it "returns self to allow chaining" do
    a = @subject.new([])
    b = a
    (a << 1).should equal(b)
    (a << 2 << 3).should equal(b)
  end

  it "correctly resizes the Array" do
    a = @subject.new([])
    a.size.should == 0
    a << :foo
    a.size.should == 1
    a << :bar << :baz
    a.size.should == 3

    a = @subject.new([1, 2, 3])
    a.shift
    a.shift
    a.shift
    a << :foo
    a.should == [:foo]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject) << 5 }.should raise_error(FrozenError)
  end
end

describe "Array#<<" do
  before { @subject = Array }

  it_behaves_like :collection_push_operator, :<<

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(Array)
  end
end

describe "Collection#<<" do
  before { @subject = Group }

  it_behaves_like :collection_push_operator, :<<

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(Group)
  end
end

describe "Array#push" do
  before { @subject = Array }

  it_behaves_like :array_push, :append

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(Array)
  end
end

describe "Collection#push" do
  before { @subject = Group }

  it_behaves_like :array_push, :append

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(@subject)
  end
end
