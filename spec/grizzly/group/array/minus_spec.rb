require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/difference'


describe "Array#-" do
  before { @subject = Array }

  it_behaves_like :array_binary_difference, :-

  it "does not return subclass instance for Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].send(@method, []).should be_an_instance_of(Array)
    CollectionSpecs::MyArray[1, 2, 3].send(@method, CollectionSpecs::MyArray[]).should be_an_instance_of(Array)
    @subject.new([1, 2, 3]).send(@method, CollectionSpecs::MyArray[]).should be_an_instance_of(Array)
  end
end

describe "Collection#-" do
  before { @subject = Group }

  it_behaves_like :array_binary_difference, :-

  it "returns subclass instances for Collection subclasses" do
    @subject.new([1, 2, 3]).send(@method, []).should be_an_instance_of(Group)
    @subject.new([1, 2, 3]).send(@method, CollectionSpecs::MyArray[]).should be_an_instance_of(Group)
    [1, 2, 3].send(@method, CollectionSpecs::MyArray[]).should be_an_instance_of(Array)
  end
end
