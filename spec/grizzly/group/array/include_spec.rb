require_relative '../../../spec_helper'


describe :collection_include, shared: true do
  it "returns true if object is present, false otherwise" do
    @subject.new([1, 2, "a", "b"]).include?("c").should == false
    @subject.new([1, 2, "a", "b"]).include?("a").should == true
  end

  it "determines presence by using element == obj" do
    o = mock('')

    @subject.new([1, 2, "a", "b"]).include?(o).should == false

    def o.==(other); other == 'a'; end

    @subject.new([1, 2, o, "b"]).include?('a').should == true

    @subject.new([1, 2.0, 3]).include?(2).should == true
  end

  it "calls == on elements from left to right until success" do
    key = "x"
    one = mock('one')
    two = mock('two')
    three = mock('three')
    one.should_receive(:==).any_number_of_times.and_return(false)
    two.should_receive(:==).any_number_of_times.and_return(true)
    three.should_not_receive(:==)
    ary = @subject.new([one, two, three])
    ary.include?(key).should == true
  end
end

describe "Collection#include?" do
  before { @subject = Group }

  it_behaves_like :collection_include, :include
end

describe "Array#include?" do
  before { @subject = Array }

  it_behaves_like :collection_include, :include
end
