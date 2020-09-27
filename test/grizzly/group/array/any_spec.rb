# require_relative '../../../spec_helper'
# 
require_relative '../../../spec_helper'

describe :collection_any, shared: true do
  describe 'with no block given (a default block of { |x| x } is implicit)' do
    it "is false if the collection is empty" do
      @empty_collection.any?.should == false
    end

    it "is false if the collection is not empty, but all the members of the collection are falsy" do
      @falsy_collection.any?.should == false
    end

    it "is true if the collection has any truthy members" do
      @not_empty_collection.any?.should == true
    end
  end

  describe 'with a block given' do
    it 'is false if the collection is empty' do
      @empty_collection.any? {|v| 1 == 1 }.should == false
    end

    it 'is true if the block returns true for any member of the collection' do
      @collection_with_members.any? {|v| v == true }.should == true
    end

    it 'is false if the block returns false for all members of the collection' do
      @collection_with_members.any? {|v| v == 42 }.should == false
    end
  end
end

describe "Collection#any?" do
  before do
    @empty_collection = Group.new []
    @falsy_collection = Group.new [false, nil, false]
    @not_empty_collection = Group.new ['anything', nil]
    @empty_collection = Group.new []
    @collection_with_members = Group.new [false, false, true, false]
    @collection_with_members = Group.new [false, false, true, false]
  end

  it_behaves_like :collection_any , :detect
end

describe "Array#any?" do
  before do
    @empty_collection = []
    @falsy_collection = [false, nil, false]
    @not_empty_collection = ['anything', nil]
    @empty_collection = []
    @collection_with_members = [false, false, true, false]
    @collection_with_members = [false, false, true, false]
  end

  it_behaves_like :collection_any , :detect
end