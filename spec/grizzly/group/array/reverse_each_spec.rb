require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumeratorize'
require_relative '../enumerable/shared/enumeratorized'

# Modifying a collection while the contents are being iterated
# gives undefined behavior. See
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/23633

describe :collection_reverse_each, shared: true do
  before :each do
    ScratchPad.record []
  end

  it "traverses array in reverse order and pass each element to block" do
    @subject.new([1, 3, 4, 6]).reverse_each { |i| ScratchPad << i }
    ScratchPad.recorded.should == [6, 4, 3, 1]
  end

  it "returns self" do
    a = @subject.new [:a, :b, :c]
    a.reverse_each { |x| }.should equal(a)
  end

  it "yields only the top level element of an empty recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.reverse_each { |i| ScratchPad << i }
    ScratchPad.recorded.should == [empty]
  end

  it "yields only the top level element of a recursive array" do
    array = CollectionSpecs.recursive_array(@subject)
    array.reverse_each { |i| ScratchPad << i }
    ScratchPad.recorded.should == [array, array, array, array, array, 3.0, 'two', 1]
  end

  it "returns the correct size when no block is given" do
    @subject.new([1, 2, 3]).reverse_each.size.should == 3
  end

  it_behaves_like :enumeratorize, :reverse_each
end

describe "Array#reverse_each" do
  before { @subject =  Array }

  it_behaves_like :collection_reverse_each, :reverse_each
  it_behaves_like :enumeratorized_with_origin_size, :reverse_each, [1,2,3]
end

describe "Collection#reverse_each" do
  before { @subject = Group }

  it_behaves_like :collection_reverse_each, :reverse_each
  it_behaves_like :enumeratorized_with_origin_size, :reverse_each, Group.new([1,2,3])
end