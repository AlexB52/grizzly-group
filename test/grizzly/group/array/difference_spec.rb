require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/difference'


ruby_version_is "2.6" do
  describe :rb_2_6_difference, shared: true do
    it_behaves_like :array_binary_difference, :difference

    it "returns a copy when called without any parameter" do
      x = @subject.new([1, 2, 3, 2])
      x.difference.should == x
      x.difference.should_not equal x
    end

    it "accepts multiple arguments" do
      x = @subject.new([1, 2, 3, 1])
      x.difference([], [0, 1], [3, 4], [3]).should == [2]
    end
  end

  describe "Array#difference" do
    before { @subject = Array }

    it_behaves_like :rb_2_6_difference, :difference

    it "does not return subclass instances for Array subclasses" do
      CollectionSpecs::MyArray[1, 2, 3].difference.should be_an_instance_of(Array)
    end
  end

  describe "Collection#difference" do
    before { @subject = Group }

    it_behaves_like :rb_2_6_difference, :difference

    it "returns subclass instances for Collection subclasses" do
      Group.new([1, 2, 3]).difference.should be_an_instance_of(Group)
    end
  end
end
