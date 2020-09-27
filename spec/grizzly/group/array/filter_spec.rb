require_relative '../../../spec_helper'
require_relative './shared/select'


ruby_version_is "2.6" do
  describe "Array#filter" do
    before { @subject = Array }

    it_behaves_like :array_select, :filter

    it 'returns an instance of a subclass' do
      @subject.new([1,2,3,4,5]).filter { false }.should be_an_instance_of(@subject)
    end
  end

  describe "Array#filter!" do
    before(:all) { @subject = Array }

    it "returns nil if no changes were made in the array" do
      @subject.new([1, 2, 3]).filter! { true }.should be_nil
    end

    it_behaves_like :keep_if, :filter!

    it 'returns an instance of a subclass' do
      @subject.new([1,2,3,4,5]).filter! { false }.should be_an_instance_of(@subject)
    end
  end

  describe "Collection#filter" do
    before { @subject = Group }

    it_behaves_like :array_select, :filter

    it 'returns an instance of a subclass' do
      @subject.new([1,2,3,4,5]).filter { false }.should be_an_instance_of(@subject)
    end
  end

  describe "Collection#filter!" do
    before { @subject = Group }

    it "returns nil if no changes were made in the array" do
      @subject.new([1, 2, 3]).filter! { true }.should be_nil
    end

    it_behaves_like :keep_if, :filter!

    it 'returns an instance of a subclass' do
      @subject.new([1,2,3,4,5]).filter! { false }.should be_an_instance_of(@subject)
    end
  end
end
