require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumeratorize'
require_relative 'shared/delete_if'
require_relative '../enumerable/shared/enumeratorized'

describe :collection_reject, shared: true do
  it "returns a new array without elements for which block is true" do
    ary = @subject.new([1, 2, 3, 4, 5])
    ary.reject { true }.should == []
    ary.reject { false }.should == ary
    ary.reject { false }.should_not equal ary
    ary.reject { nil }.should == ary
    ary.reject { nil }.should_not equal ary
    ary.reject { 5 }.should == []
    ary.reject { |i| i < 3 }.should == [3, 4, 5]
    ary.reject { |i| i % 2 == 0 }.should == [1, 3, 5]
  end

  it "returns self when called on an Array emptied with #shift" do
    array = @subject.new([1])
    array.shift
    array.reject { |x| true }.should == []
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.reject { false }.should == [empty]
    empty.reject { true }.should == []

    array = CollectionSpecs.recursive_array(@subject)
    array.reject { false }.should == [1, 'two', 3.0, array, array, array, array, array]
    array.reject { true }.should == []
  end

  # Collection Modification Specs
  # it "does not return subclass instance on Array subclasses" do
  #   CollectionSpecs::MyArray[1, 2, 3].reject { |x| x % 2 == 0 }.should be_an_instance_of(Array)
  # end

  it "does not retain instance variables" do
    array = @subject.new([])
    array.instance_variable_set("@variable", "value")
    array.reject { false }.instance_variable_get("@variable").should == nil
  end

  it_behaves_like :enumeratorize, :reject
  # TODO : Refactor ::enumeratorized_with_origin_size
  # it_behaves_like :enumeratorized_with_origin_size, :reject, [1,2,3]
end

describe :collection_reject!, shared: true do
  it "removes elements for which block is true" do
    a = @subject.new([3, 4, 5, 6, 7, 8, 9, 10, 11])
    a.reject! { |i| i % 2 == 0 }.should equal(a)
    a.should == [3, 5, 7, 9, 11]
    a.reject! { |i| i > 8 }
    a.should == [3, 5, 7]
    a.reject! { |i| i < 4 }
    a.should == [5, 7]
    a.reject! { |i| i == 5 }
    a.should == [7]
    a.reject! { true }
    a.should == []
    a.reject! { true }
    a.should == []
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty_dup = empty.dup
    empty.reject! { false }.should == nil
    empty.should == empty_dup

    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.reject! { true }.should == []
    empty.should == []

    array = CollectionSpecs.recursive_array(@subject)
    array_dup = array.dup
    array.reject! { false }.should == nil
    array.should == array_dup

    array = CollectionSpecs.recursive_array(@subject)
    array.reject! { true }.should == []
    array.should == []
  end

  it "returns nil when called on an Array emptied with #shift" do
    array = @subject.new([1])
    array.shift
    array.reject! { |x| true }.should == nil
  end

  it "returns nil if no changes are made" do
    a = @subject.new([1, 2, 3])

    a.reject! { |i| i < 0 }.should == nil

    a.reject! { true }
    a.reject! { true }.should == nil
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    CollectionSpecs.frozen_array(@subject).reject!.should be_an_instance_of(Enumerator)
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).reject! {} }.should raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    -> { CollectionSpecs.empty_frozen_array(@subject).reject! {} }.should raise_error(FrozenError)
  end

  it "does not truncate the array is the block raises an exception" do
    a = @subject.new([1, 2, 3])
    begin
      a.reject! { raise StandardError, 'Oops' }
    rescue
    end

    a.should == [1, 2, 3]
  end

  it "only removes elements for which the block returns true, keeping the element which raised an error." do
    a = @subject.new([1, 2, 3, 4])
    begin
      a.reject! do |x|
        case x
        when 2 then true
        when 3 then raise StandardError, 'Oops'
        else false
        end
      end
    rescue StandardError
    end

    a.should == [1, 3, 4]
  end

  # TODO : Make sure the enumerable are converted too
  it_behaves_like :enumeratorize, :reject!
  # it_behaves_like :enumeratorized_with_origin_size, :reject!, [1,2,3]
  it_behaves_like :delete_if, :reject!
end


describe "Array#reject" do
  before(:all) { @subject = Array }

  it_behaves_like :collection_reject, :reject
  it_behaves_like :enumeratorized_with_origin_size, :reject, [1,2,3]

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].reject { |x| x % 2 == 0 }.should be_an_instance_of(Array)
  end
end

describe "Collection#reject" do
  before(:all) { @subject = Group }

  it_behaves_like :collection_reject, :reject
  it_behaves_like :enumeratorized_with_origin_size, :reject, Group.new([1,2,3])

  it "returns subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).reject { |x| x % 2 == 0 }.should be_an_instance_of(Group)
  end
end

describe "Array#reject!" do
  before(:all) { @subject = Array }

  it_behaves_like :collection_reject!, :reject!
  it_behaves_like :enumeratorized_with_origin_size, :reject!, [1,2,3]

  it "returns subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].reject! { |x| x % 2 == 0 }.should be_an_instance_of(CollectionSpecs::MyArray)
  end
end

describe "Collection#reject!" do
  before(:all) { @subject = Group }

  it_behaves_like :collection_reject!, :reject!
  it_behaves_like :enumeratorized_with_origin_size, :reject!, Group.new([1,2,3])

  it "returns subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).reject! { |x| x % 2 == 0 }.should be_an_instance_of(Group)
  end
end