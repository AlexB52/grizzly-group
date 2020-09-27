require_relative '../../../spec_helper'
require_relative 'shared/select'

describe "Array#select" do
  before { @subject = Array }

  it_behaves_like :array_select, :select

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].select { true }.should be_an_instance_of(Array)
  end
end

describe "Collection#select" do
  before { @subject = Group }

  it_behaves_like :array_select, :select

  it "returns subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).select { true }.should be_an_instance_of(Group)
  end
end

describe "Array#select!" do
  before { @subject = Array }

  it "returns nil if no changes were made in the array" do
    @subject.new([1, 2, 3]).select! { true }.should be_nil
  end

  it_behaves_like :keep_if, :select!
end

describe "Collection#select!" do
  before { @subject = Group }

  it "returns nil if no changes were made in the array" do
    @subject.new([1, 2, 3]).select! { true }.should be_nil
  end

  it_behaves_like :keep_if, :select!
end
