require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumeratorize'
require_relative 'shared/delete_if'
require_relative '../enumerable/shared/enumeratorized'

describe :collection_delete_if, shared: true do
  before do
    @a = @subject.new([ "a", "b", "c" ])
  end

  it_behaves_like :enumeratorize, :delete_if
  it_behaves_like :delete_if, :delete_if

  it "removes each element for which block returns true" do
    @a = @subject.new([ "a", "b", "c" ])
    @a.delete_if { |x| x >= "b" }
    @a.should == ["a"]
  end

  it "returns self" do
    @a.delete_if{ true }.equal?(@a).should be_true
  end

  it "returns self when called on an Array emptied with #shift" do
    array = @subject.new([1])
    array.shift
    array.delete_if { |x| true }.should equal(array)
  end

  # NEW INTERFACE
  # it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
  #   enum = @a.delete_if
  #   enum.should be_an_instance_of(Enumerator)
  #   @a.should_not be_empty
  #   enum.each { true }
  #   @a.should be_empty
  # end

  # it "returns an Enumerator if no block given, and the array is frozen" do
  #   @a.freeze.delete_if.should be_an_instance_of(Enumerator)
  # end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).delete_if {} }.should raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).delete_if {} }.should raise_error(FrozenError)
  end

  ruby_version_is ''...'2.7' do
    it "keeps tainted status" do
      @a.taint
      @a.tainted?.should be_true
      @a.delete_if{ true }
      @a.tainted?.should be_true
    end

    it "keeps untrusted status" do
      @a.untrust
      @a.untrusted?.should be_true
      @a.delete_if{ true }
      @a.untrusted?.should be_true
    end
  end
end

describe "Array#delete_if" do
  before { @subject =  Array }

  it_behaves_like :collection_delete_if, :delete_if
  it_behaves_like :enumeratorized_with_origin_size, :delete_if, [1,2,3]

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete_if { |x| x < 3 }
    a.should be_an_instance_of(@subject)
  end

  it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
    enum = @a.delete_if
    enum.should be_an_instance_of(Enumerator)
    @a.should_not be_empty
    enum.each { true }
    @a.should be_empty
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    @a.freeze.delete_if.should be_an_instance_of(Enumerator)
  end
end

describe "Collection#delete_if" do
  before { @subject = Group }

  it_behaves_like :collection_delete_if, :delete_if
  it_behaves_like :enumeratorized_with_origin_size, :delete_if, Group.new([1,2,3])

  it "returns a subclass instance of Array" do
    a = @subject.new([1,2,3,4,5])
    a.delete_if { |x| x < 3 }
    a.should be_an_instance_of(@subject)
  end

  it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
    enum = @a.delete_if
    enum.should be_an_instance_of(Grizzly::Enumerator)
    @a.should_not be_empty
    enum.each { true }
    @a.should be_empty
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    @a.freeze.delete_if.should be_an_instance_of(Grizzly::Enumerator)
  end
end