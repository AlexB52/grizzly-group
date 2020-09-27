require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/join'


describe :collection_join, shared: true do

  it_behaves_like :array_join_with_string_separator,  :join
  it_behaves_like :array_join_with_default_separator, :join

  it "does not separate elements when the passed separator is nil" do
    @subject.new([1, 2, 3]).join(nil).should == '123'
  end

  it "calls #to_str to convert the separator to a String" do
    sep = mock("separator")
    sep.should_receive(:to_str).and_return(", ")
    @subject.new([1, 2]).join(sep).should == "1, 2"
  end

  it "does not call #to_str on the separator if the array is empty" do
    sep = mock("separator")
    sep.should_not_receive(:to_str)
    @subject.new([]).join(sep).should == ""
  end

  it "raises a TypeError if the separator cannot be coerced to a String by calling #to_str" do
    obj = mock("not a string")
    -> { @subject.new([1, 2]).join(obj) }.should raise_error(TypeError)
  end

  it "raises a TypeError if passed false as the separator" do
    -> { @subject.new([1, 2]).join(false) }.should raise_error(TypeError)
  end
end

describe :collection_join_with_seperator, shared: true do
  before :each do
    @before_separator = $,
  end

  after :each do
    suppress_warning {$, = @before_separator}
  end

  it "separates elements with default separator when the passed separator is nil" do
    suppress_warning {
      $, = "_"
      @subject.new([1, 2, 3]).join(nil).should == '1_2_3'
    }
  end
end

describe "Array#join" do
  before { @subject = Array }

  it_behaves_like :collection_join, :join
  it_behaves_like :collection_join_with_seperator, :join
end

describe "Collection#join" do
  before { @subject = Group }

  it_behaves_like :collection_join, :join
  it_behaves_like :collection_join_with_seperator, :join
end