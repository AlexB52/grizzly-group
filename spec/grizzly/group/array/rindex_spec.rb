require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative '../enumerable/shared/enumeratorized'


# Modifying a collection while the contents are being iterated
# gives undefined behavior. See
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/23633

describe :collection_rindex, shared: true do
  it "returns the first index backwards from the end where element == to object" do
    key = 3
    uno = mock('one')
    dos = mock('two')
    tres = mock('three')
    tres.should_receive(:==).any_number_of_times.and_return(false)
    dos.should_receive(:==).any_number_of_times.and_return(true)
    uno.should_not_receive(:==)
    ary = [uno, dos, tres]

    @subject.new(ary).rindex(key).should == 1
  end

  it "returns size-1 if last element == to object" do
    @subject.new([2, 1, 3, 2, 5]).rindex(5).should == 4
  end

  it "returns 0 if only first element == to object" do
    @subject.new([2, 1, 3, 1, 5]).rindex(2).should == 0
  end

  it "returns nil if no element == to object" do
    @subject.new([1, 1, 3, 2, 1, 3]).rindex(4).should == nil
  end

  it "returns correct index even after delete_at" do
    array = @subject.new(["fish", "bird", "lion", "cat"])
    array.delete_at(0)
    array.rindex("lion").should == 1
  end

  it "properly handles empty recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.rindex(empty).should == 0
    empty.rindex(1).should be_nil
  end

  it "properly handles recursive arrays" do
    array = CollectionSpecs.recursive_array(@subject)
    array.rindex(1).should == 0
    array.rindex(array).should == 7
  end

  it "accepts a block instead of an argument" do
    @subject.new([4, 2, 1, 5, 1, 3]).rindex { |x| x < 2 }.should == 4
  end

  it "ignores the block if there is an argument" do
    -> {
      @subject.new([4, 2, 1, 5, 1, 3]).rindex(5) { |x| x < 2 }.should == 3
    }.should complain(/given block not used/)
  end

  it "rechecks the array size during iteration" do
    ary = @subject.new([4, 2, 1, 5, 1, 3])
    seen = []
    ary.rindex { |x| seen << x; ary.clear; false }

    seen.should == [3]
  end

  describe "given no argument and no block" do
    it "produces an Enumerator" do
      enum = @subject.new([4, 2, 1, 5, 1, 3]).rindex
      enum.should be_an_instance_of(Enumerator)
      enum.each { |x| x < 2 }.should == 4
    end
  end
  # TODO : Refactor :enumeratorized_with_unknown_size
  # it_behaves_like :enumeratorized_with_unknown_size, :bsearch, [1,2,3]
end

describe "Array#rindex" do
  before { @subject = Array }

  it_behaves_like :collection_rindex, :rindex
  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, [1,2,3]
end

describe "Collection#rindex" do
  before { @subject = Group }

  it_behaves_like :collection_rindex, :rindex
  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, Group.new([1,2,3])
end