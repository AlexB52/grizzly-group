describe :array_push, shared: true do
  it "appends the arguments to the array" do
    a = @subject.new([ "a", "b", "c" ])
    a.send(@method, "d", "e", "f").should equal(a)
    a.send(@method).should == ["a", "b", "c", "d", "e", "f"]
    a.send(@method, 5)
    a.should == ["a", "b", "c", "d", "e", "f", 5]

    a = @subject.new([0, 1])
    a.send(@method, 2)
    a.should == [0, 1, 2]
  end

  it "isn't confused by previous shift" do
    a = @subject.new([ "a", "b", "c" ])
    a.shift
    a.send(@method, "foo")
    a.should == ["b", "c", "foo"]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.send(@method, :last).should == [empty, :last]

    array = CollectionSpecs.recursive_array(@subject)
    array.send(@method, :last).should == [1, 'two', 3.0, array, array, array, array, array, :last]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).send(@method, 1) }.should raise_error(FrozenError)
    -> { CollectionSpecs.frozen_array(@subject).send(@method) }.should raise_error(FrozenError)
  end
end
