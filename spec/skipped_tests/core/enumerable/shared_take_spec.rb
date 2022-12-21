require_relative "../../spec_helper"

# - core/enumerable/shared/take.rb:7
# - core/enumerable/shared/take.rb:12
# - core/enumerable/shared/take.rb:19
# - core/enumerable/shared/take.rb:23
# - core/enumerable/shared/take.rb:31
# - core/enumerable/shared/take.rb:36
# - core/enumerable/shared/take.rb:50
# - core/enumerable/shared/take.rb:55
describe :enumerable_take, shared: true do
  before :each do
    @values = Grizzly::Collection.new([4, 3, 2, 1, 0, -1])
    @enum = Numerous.new(@values)
    @method = :first
  end

  it "returns the first count elements if given a count" do
    @enum.send(@method, 2).should == Numerous.new([4, 3])
    @enum.send(@method, 4).should == Numerous.new([4, 3, 2, 1]) # See redmine #1686 !
  end

  it "returns an instance of the subclass" do
    @enum.send(@method, 0).should be_an_instance_of(Numerous)
    @enum.send(@method, 1).should be_an_instance_of(Numerous)
    @enum.send(@method, 2).should be_an_instance_of(Numerous)
  end

  it "returns an empty array when passed count on an empty array" do
    empty = Grizzly::Collection.new([])
    empty.send(@method, 0).should == Grizzly::Collection.new([])
    empty.send(@method, 1).should == Grizzly::Collection.new([])
    empty.send(@method, 2).should == Grizzly::Collection.new([])
  end

  it "returns an empty array when passed count == 0" do
    @enum.send(@method, 0).should == Numerous.new([])
  end

  it "returns an array containing the first element when passed count == 1" do
    @enum.send(@method, 1).should == Numerous.new([4])
  end

  it "returns the entire array when count > length" do
    @enum.send(@method, 100).should == Numerous.new(@values)
    @enum.send(@method, 8).should == Numerous.new(@values)  # See redmine #1686 !
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(3).at_most(:twice) # called twice, no apparent reason. See redmine #1554
    @enum.send(@method, obj).should == Numerous.new([4, 3, 2])
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = YieldsMulti.new
    multi.send(@method, 1).should == YieldsMulti.new([Grizzly::Collection.new([1, 2])])
  end

  it "consumes only what is needed" do
    thrower = ThrowingEach.new
    thrower.send(@method, 0).should == ThrowingEach.new([])
    counter = EachCounter.new([1,2,3,4])
    counter.send(@method, 2).should == EachCounter.new([1,2])
    counter.times_called.should == 1
    counter.times_yielded.should == 2
  end
end

describe 'Enumerable#take' do
  it_behaves_like :enumerable_take, :first
  it_behaves_like :enumerable_take, :take
end
