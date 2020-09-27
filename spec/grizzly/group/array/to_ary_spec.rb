require_relative '../../../spec_helper'
require_relative 'fixtures/classes'


describe :collectio_to_ary, shared: true do
  it "returns self" do
    a = @subject.new([1, 2, 3])
    a.should equal(a.to_ary)

    a = CollectionSpecs::MyArray[1, 2, 3]
    a.should equal(a.to_ary)
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.to_ary.should == empty

    array = CollectionSpecs.recursive_array(@subject)
    array.to_ary.should == array
  end

end

describe "Array#to_ary" do
  before { @subject = Array }

  it_behaves_like :collectio_to_ary, :to_ary
end

describe "Collection#to_ary" do
  before { @subject = Group }

  it_behaves_like :collectio_to_ary, :to_ary
end