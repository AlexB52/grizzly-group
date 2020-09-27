require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative '../enumerable/shared/enumeratorized'

describe :collection_sort_by!, shared: true do
  it "sorts array in place by passing each element to the given block" do
    a = @subject.new([-100, -2, 1, 200, 30000])
    a.sort_by!{ |e| e.to_s.size }
    a.should == [1, -2, 200, -100, 30000]
  end

  it "returns an Enumerator if not given a block" do
    @subject.new((1..10).to_a).sort_by!.should be_an_instance_of(Enumerator)
  end

  # New Interface

  # it "completes when supplied a block that always returns the same result" do
  #   a = @subject.new([2, 3, 5, 1, 4])
  #   a.sort_by!{  1 }
  #   a.should be_an_instance_of(@subject)
  #   a.sort_by!{  0 }
  #   a.should be_an_instance_of(@subject)
  #   a.sort_by!{ -1 }
  #   a.should be_an_instance_of(@subject)
  # end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).sort_by! {}}.should raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).sort_by! {}}.should raise_error(FrozenError)
  end

  it "returns the specified value when it would break in the given block" do
    @subject.new([1, 2, 3]).sort_by!{ break :a }.should == :a
  end

  it "makes some modification even if finished sorting when it would break in the given block" do
    partially_sorted = (1..5).map{|i|
      ary = @subject.new([5, 4, 3, 2, 1])
      ary.sort_by!{|x,y| break if x==i; x<=>y}
      ary
    }
    partially_sorted.any?{|ary| ary != [1, 2, 3, 4, 5]}.should be_true
  end

  it "changes nothing when called on a single element array" do
    @subject.new([1]).sort_by!(&:to_s).should == [1]
  end

  # TODO : Refactor :enumeratorized_with_origin_size
  # it_behaves_like :enumeratorized_with_origin_size, :sort_by!, [1,2,3]
end

describe "Array#sort_by!" do
  before { @subject = Array }

  it_behaves_like :collection_sort_by!, :sort_by!
  it_behaves_like :enumeratorized_with_origin_size, :sort_by!, [1,2,3]

  it "completes when supplied a block that always returns the same result" do
    a = @subject.new([2, 3, 5, 1, 4])
    a.sort_by!{  1 }
    a.should be_an_instance_of(@subject)
    a.sort_by!{  0 }
    a.should be_an_instance_of(@subject)
    a.sort_by!{ -1 }
    a.should be_an_instance_of(@subject)
  end
end

describe "Collection#sort_by!" do
  before { @subject = Group }

  it_behaves_like :collection_sort_by!, :sort_by!
  it_behaves_like :enumeratorized_with_origin_size, :sort_by!, Group.new([1,2,3])

  it "completes when supplied a block that always returns the same result" do
    a = @subject.new([2, 3, 5, 1, 4])
    a.sort_by!{  1 }
    a.should be_an_instance_of(@subject)
    a.sort_by!{  0 }
    a.should be_an_instance_of(@subject)
    a.sort_by!{ -1 }
    a.should be_an_instance_of(@subject)
  end
end
