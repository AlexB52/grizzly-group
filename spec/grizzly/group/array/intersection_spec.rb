require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/intersection'


ruby_version_is "2.7" do
  describe :rb_2_7_intersection, shared: true do
    it "accepts multiple arguments" do
      @subject.new([1, 2, 3, 4]).intersection([1, 2, 3], [2, 3, 4]).should == [2, 3]
    end

    it "preserves elements order from original array" do
      @subject.new([1, 2, 3, 4]).intersection([3, 2, 1]).should == [1, 2, 3]
    end
  end

  describe "Array#intersection" do
    before { @subject = Array }

    it_behaves_like :array_intersection, :intersection
    it_behaves_like :rb_2_7_intersection, :intersection
  end

  describe "Collection#intersection" do
    before { @subject = Group }

    it_behaves_like :array_intersection, :intersection
    it_behaves_like :rb_2_7_intersection, :intersection
  end
end

describe "Array#&" do
  before { @subject = Array }

  it_behaves_like :array_intersection, :&

  it "does return subclass instances for Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].send(@method, []).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Array)
    [].send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Array)
  end
end

describe "Collection#&" do
  before { @subject = Group }

  it_behaves_like :array_intersection, :&

  it "returns subclass instances for Array subclasses" do
    Group.new([1, 2, 3]).send(@method, []).should be_an_instance_of(Group)
    Group.new([1, 2, 3]).send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Group)
    Group.new([]).send(@method, CollectionSpecs::MyArray[1, 2, 3]).should be_an_instance_of(Group)
  end
end
