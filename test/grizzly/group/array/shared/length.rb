describe :array_length, shared: true do
  it "returns the number of elements" do
    @subject.new([]).send(@method).should == 0
    @subject.new([1, 2, 3]).send(@method).should == 3
  end

  it "properly handles recursive arrays" do
    CollectionSpecs.empty_recursive_array(@subject).send(@method).should == 1
    CollectionSpecs.recursive_array(@subject).send(@method).should == 8
  end
end
