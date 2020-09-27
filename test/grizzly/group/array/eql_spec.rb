require_relative '../../../spec_helper'
require_relative 'shared/eql'

describe :collection_eql, shared: true do
  it "returns false if any corresponding elements are not #eql?" do
    @subject.new([1, 2, 3, 4]).should_not eql([1, 2, 3, 4.0])
  end

  it "returns false if other is not a kind of Array" do
    obj = mock("array eql?")
    obj.should_not_receive(:to_ary)
    obj.should_not_receive(:eql?)

    @subject.new([1, 2, 3]).should_not eql(obj)
  end
end


describe "Array#eql?" do
  before { @subject = Array }

  it_behaves_like :collection_eql, :eql?
  it_behaves_like :array_eql, :eql?
end

describe "Collection#eql?" do
  before { @subject = Group }

  it_behaves_like :collection_eql, :eql?
  it_behaves_like :array_eql, :eql?
end
