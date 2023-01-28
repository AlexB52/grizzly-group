require_relative '../spec_helper'

describe "Enumerator#inspect" do
  describe "shows a representation of the Enumerator" do
    it "including receiver and method" do
      Grizzly::Enumerator.new((1..3).each).inspect.should == "#<Grizzly::Enumerator: 1..3:each>"
    end

    it "including receiver and method and arguments" do
      Grizzly::Enumerator.new((1..3).each_slice(2)).inspect.should == "#<Grizzly::Enumerator: 1..3:each_slice(2)>"
    end

    it "including the nested Enumerator" do
      Grizzly::Enumerator.new((1..3).each.each_slice(2)).inspect.should == "#<Grizzly::Enumerator: #<Grizzly::Enumerator: 1..3:each>:each_slice(2)>"
    end

    it "including the nested Enumerator" do
      a = Grizzly::Collection.new([1,2,3]).each.select
      a.inspect.should == "#<Grizzly::Enumerator: #<Grizzly::Enumerator: [1, 2, 3]:each>:select>"
    end
  end
end
