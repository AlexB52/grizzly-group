describe :array_intersection, shared: true do
  it "creates an array with elements common to both arrays (intersection)" do
    @subject.new([]).send(@method, []).should == []
    @subject.new([1, 2]).send(@method, []).should == []
    @subject.new([]).send(@method, [1, 2]).should == []
    @subject.new([ 1, 3, 5 ]).send(@method, [ 1, 2, 3 ]).should == [1, 3]
  end

  it "creates an array with no duplicates" do
    @subject.new([ 1, 1, 3, 5 ]).send(@method, [ 1, 2, 3 ]).uniq!.should == nil
  end

  it "creates an array with elements in order they are first encountered" do
    @subject.new([ 1, 2, 3, 2, 5 ]).send(@method, [ 5, 2, 3, 4 ]).should == [2, 3, 5]
  end

  it "does not modify the original Array" do
    a = @subject.new([1, 1, 3, 5])
    a.send(@method, [1, 2, 3]).should == [1, 3]
    a.should == [1, 1, 3, 5]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.send(@method, empty).should == empty

    CollectionSpecs.recursive_array(@subject).send(@method, []).should == []
    [].send(@method, CollectionSpecs.recursive_array(@subject)).should == []

    CollectionSpecs.recursive_array(@subject).send(@method, CollectionSpecs.recursive_array(@subject)).should == [1, 'two', 3.0, CollectionSpecs.recursive_array(@subject)]
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = mock('[1,2,3]')
    obj.should_receive(:to_ary).and_return([1, 2, 3])
    @subject.new([1, 2]).send(@method, obj).should == ([1, 2])
  end

  it "determines equivalence between elements in the sense of eql?" do
    not_supported_on :opal do
      @subject.new([5.0, 4.0]).send(@method, [5, 4]).should == []
    end

    str = "x"
    @subject.new([str]).send(@method, [str.dup]).should == [str]

    obj1 = mock('1')
    obj2 = mock('2')
    obj1.stub!(:hash).and_return(0)
    obj2.stub!(:hash).and_return(0)
    obj1.should_receive(:eql?).at_least(1).and_return(true)
    obj2.stub!(:eql?).and_return(true)

    @subject.new([obj1]).send(@method, [obj2]).should == [obj1]
    @subject.new([obj1, obj1, obj2, obj2]).send(@method, [obj2]).should == [obj1]

    obj1 = mock('3')
    obj2 = mock('4')
    obj1.stub!(:hash).and_return(0)
    obj2.stub!(:hash).and_return(0)
    obj1.should_receive(:eql?).at_least(1).and_return(false)

    @subject.new([obj1]).send(@method, [obj2]).should == []
    @subject.new([obj1, obj1, obj2, obj2]).send(@method, [obj2]).should == [obj2]
  end

  it "does not call to_ary on array subclasses" do
    @subject.new([5, 6]).send(@method, CollectionSpecs::ToAryArray[1, 2, 5, 6]).should == [5, 6]
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = mock('x')
    x.stub!(:hash).and_return(42)
    x.stub!(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    @subject.new([x]).send(@method, [x]).should == [x]
  end
end
