describe :array_clone, shared: true do
  it "returns an Array or a subclass instance" do
    [].send(@method).should be_an_instance_of(Array)
    Group.new([]).send(@method).should be_an_instance_of(Group)
    CollectionSpecs::MyArray[1, 2].send(@method).should be_an_instance_of(CollectionSpecs::MyArray)
  end

  it "produces a shallow copy where the references are directly copied" do
    a = @subject.new([mock('1'), mock('2')])
    b = a.send @method
    b.first.should equal a.first
    b.last.should equal a.last
  end

  it "creates a new array containing all elements or the original" do
    a = @subject.new([1, 2, 3, 4])
    b = a.send @method
    b.should == a
    b.__id__.should_not == a.__id__
  end

  ruby_version_is ''...'2.7' do
    it "copies taint status from the original" do
      a = @subject.new([1, 2, 3, 4])
      b = @subject.new([1, 2, 3, 4])
      a.taint
      aa = a.send @method
      bb = b.send @method

      aa.tainted?.should == true
      bb.tainted?.should == false
    end

    it "copies untrusted status from the original" do
      a = @subject.new([1, 2, 3, 4])
      b = @subject.new([1, 2, 3, 4])
      a.untrust
      aa = a.send @method
      bb = b.send @method

      aa.untrusted?.should == true
      bb.untrusted?.should == false
    end
  end
end
