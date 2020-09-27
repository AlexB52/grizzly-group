require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

ruby_version_is "2.7" do
  describe :collection_tally, shared: true do
    before :each do
      ScratchPad.record []
    end

    it "returns a hash with counts according to the value" do
      enum = @subject.new(EnumerableSpecs::Numerous.new('foo', 'bar', 'foo', 'baz'))
      enum.tally.should == { 'foo' => 2, 'bar' => 1, 'baz' => 1}
    end

    it "returns a hash without default" do
      hash = @subject.new(EnumerableSpecs::Numerous.new('foo', 'bar', 'foo', 'baz')).tally
      hash.default_proc.should be_nil
      hash.default.should be_nil
    end

    it "returns an empty hash for empty enumerables" do
      @subject.new(EnumerableSpecs::Empty.new).tally.should == {}
    end

    # it "counts values as gathered array when yielded with multiple arguments" do
    #   EnumerableSpecs::YieldsMixed2.new.tally.should == EnumerableSpecs::YieldsMixed2.gathered_yields.group_by(&:itself).transform_values(&:size)
    # end

    it "does not call given block" do
      enum = @subject.new(EnumerableSpecs::Numerous.new('foo', 'bar', 'foo', 'baz'))
      enum.tally { |v| ScratchPad << v }
      ScratchPad.recorded.should == []
    end
  end

  describe "Array#tally" do
    before { @subject = Array }

    it_behaves_like :collection_tally, :tally
  end

  describe "Collection#tally" do
    before { @subject = Group }

    it_behaves_like :collection_tally, :tally
  end
end
