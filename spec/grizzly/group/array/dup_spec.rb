require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/clone'


describe :collection_dup, shared: true do
  it_behaves_like :array_clone, :dup # FIX: no, clone and dup are not alike

  it "does not copy frozen status from the original" do
    a = @subject.new([1, 2, 3, 4])
    b = @subject.new([1, 2, 3, 4])
    a.freeze
    aa = a.dup
    bb = b.dup

    aa.frozen?.should be_false
    bb.frozen?.should be_false
  end

  it "does not copy singleton methods" do
    a = @subject.new([1, 2, 3, 4])
    b = @subject.new([1, 2, 3, 4])
    def a.a_singleton_method; end
    aa = a.dup
    bb = b.dup

    a.respond_to?(:a_singleton_method).should be_true
    b.respond_to?(:a_singleton_method).should be_false
    aa.respond_to?(:a_singleton_method).should be_false
    bb.respond_to?(:a_singleton_method).should be_false
  end
end

describe "Array#dup" do
  before { @subject = Array }

  it_behaves_like :collection_dup, :dup
end

describe "Collection#dup" do
  before { @subject = Group }

  it_behaves_like :collection_dup, :dup
end
