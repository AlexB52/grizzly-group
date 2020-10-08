require_relative '../../../spec_helper'

describe "Grizzly::Enumerator#inspect" do
  before { @subject = Grizzly::Enumerator }

  describe "shows a representation of the Enumerator" do
    it "including receiver and method" do
      @subject.new((1..3), :each).inspect.should == "#<Grizzly::Enumerator: 1..3:each>"
    end

    it "including receiver and method and arguments" do
      @subject.new((1..3), :each_slice, nil, 2).inspect.should == "#<Grizzly::Enumerator: 1..3:each_slice(2)>"
    end

    it "including the nested Enumerator" do
      @subject.new((1..3).each, :each_slice, nil, 2).inspect.should == "#<Grizzly::Enumerator: #<Grizzly::Enumerator: 1..3:each>:each_slice(2)>"
    end
  end
end
