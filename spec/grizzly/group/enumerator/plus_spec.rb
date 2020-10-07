require_relative '../../../spec_helper'

ruby_version_is "2.6" do
  describe "Grizzly::Enumerator#+" do
    before :each do
      @subject = Grizzly::Enumerator
      ScratchPad.record []
    end

    it "returns a chain of self and provided enumerators" do
      one   = @subject.new(Enumerator.new { |y| y << 1 })
      two   = @subject.new(Enumerator.new { |y| y << 2 })
      three = @subject.new(Enumerator.new { |y| y << 3 })

      chain = one + two + three

      chain.should be_an_instance_of(Enumerator::Chain)
      chain.each { |item| ScratchPad << item }
      ScratchPad.recorded.should == [1, 2, 3]
    end

    it "calls #each on each argument" do
      enum = @subject.new(Enumerator.new { |y| y << "one" })

      obj1 = mock("obj1")
      obj1.should_receive(:each).once.and_yield("two")

      obj2 = mock("obj2")
      obj2.should_receive(:each).once.and_yield("three")

      chain = enum + obj1 + obj2
      chain.each { |item| ScratchPad << item }
      ScratchPad.recorded.should == ["one", "two", "three"]
    end
  end
end
