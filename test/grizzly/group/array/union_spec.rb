require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/union'


ruby_version_is "2.6" do
  describe :rb_2_6_union, shared: true do
    it "returns unique elements when given no argument" do
      x = @subject.new([1, 2, 3, 2])
      x.union.should == [1, 2, 3]
    end

    it "accepts multiple arguments" do
      x = @subject.new([1, 2, 3])
      x.union(x, x, x, x, [3, 4], x).should == [1, 2, 3, 4]
    end
  end

  describe "Array#union" do
    before { @subject = Array }

    it_behaves_like :array_binary_union, :union
    it_behaves_like :rb_2_6_union, :union

    it "does not return subclass instances for Array subclasses" do
      CollectionSpecs::MyArray[1, 2, 3].union.should be_an_instance_of(Array)
    end
  end

  describe "Collection#union" do
    before { @subject = Group }

    it_behaves_like :array_binary_union, :union
    it_behaves_like :rb_2_6_union, :union

    it "returns subclass instances for Collection subclasses" do
      Group.new([1, 2, 3]).union.should be_an_instance_of(Group)
    end
  end
end

describe "Array#|" do
  before { @subject =  Array }

  it_behaves_like :array_binary_union, :|

  it "does not return subclass instances for Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].send(@method, []).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Array)
    [].send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Array)
  end
end

describe "Collection#|" do
  before { @subject = Group }

  it_behaves_like :array_binary_union, :|

  it "returns subclass instances for Array subclasses" do
    Group.new([1, 2, 3]).send(@method, []).should be_an_instance_of(Group)
    Group.new([1, 2, 3]).send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Group)
    Group.new([]).send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Group)
  end
end