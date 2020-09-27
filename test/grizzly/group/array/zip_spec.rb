require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_zip, shared: true do
  it "returns an array of arrays containing corresponding elements of each array" do
    @subject.new([1, 2, 3, 4]).zip(["a", "b", "c", "d", "e"]).should ==
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
  end

  it "fills in missing values with nil" do
    @subject.new([1, 2, 3, 4, 5]).zip(["a", "b", "c", "d"]).should ==
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, nil]]
  end

  it "properly handles recursive arrays" do
    a = @subject.new([]); a << a
    b = @subject.new([1]); b << b

    a.zip(a).should == [ [a[0], a[0]] ]
    a.zip(b).should == [ [a[0], b[0]] ]
    b.zip(a).should == [ [b[0], a[0]], [b[1], a[1]] ]
    b.zip(b).should == [ [b[0], b[0]], [b[1], b[1]] ]
  end

  it "calls #to_ary to convert the argument to an Array" do
    obj = mock('[3,4]')
    obj.should_receive(:to_ary).and_return([3, 4])
    @subject.new([1, 2]).zip(obj).should == [[1, 3], [2, 4]]
  end

  it "uses #each to extract arguments' elements when #to_ary fails" do
    obj = Class.new do
      def each(&b)
        [3,4].each(&b)
      end
    end.new

    @subject.new([1, 2]).zip(obj).should == [[1, 3], [2, 4]]
  end

  it "stops at own size when given an infinite enumerator" do
    @subject.new([1, 2]).zip(10.upto(Float::INFINITY)).should == [[1, 10], [2, 11]]
  end

  it "fills nil when the given enumerator is shorter than self" do
    obj = Object.new
    def obj.each
      yield 10
    end
    @subject.new([1, 2]).zip(obj).should == [[1, 10], [2, nil]]
  end

  it "calls block if supplied" do
    values = []
    @subject.new([1, 2, 3, 4]).zip(["a", "b", "c", "d", "e"]) { |value|
      values << value
    }.should == nil

    values.should == [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
  end

  # New interface
  # it "does not return subclass instance on Array subclasses" do
  #   CollectionSpecs::MyArray[1, 2, 3].zip(["a", "b"]).should be_an_instance_of(Array)
  # end
end


describe "Array#zip" do
  before { @subject = Array }

  it_behaves_like :collection_zip, :zip

  it "does not return subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].zip(["a", "b"]).should be_an_instance_of(Array)
  end
end

describe "Collection#zip" do
  before { @subject = Group }

  it_behaves_like :collection_zip, :zip

  it "returns an array of subclass instances on Array subclasses" do
    result = Group.new([1, 2, 3]).zip(["a", "b"])
    a, b, c = result
    result.should be_an_instance_of(Array)
    a.should be_an_instance_of(Group)
    b.should be_an_instance_of(Group)
    c.should be_an_instance_of(Group)
  end
end