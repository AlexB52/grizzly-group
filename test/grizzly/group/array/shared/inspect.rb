require_relative '../fixtures/classes'
require_relative '../fixtures/encoded_strings'

describe :array_inspect, shared: true do
  it "returns a string" do
    @subject.new([1, 2, 3]).send(@method).should be_an_instance_of(String)
  end

  it "returns '[]' for an empty Array" do
    @subject.new([]).send(@method).should == "[]"
  end

  it "calls inspect on its elements and joins the results with commas" do
    items = @subject.new(3) do |i|
      obj = mock(i.to_s)
      obj.should_receive(:inspect).and_return(i.to_s)
      obj
    end
    items.send(@method).should == "[0, 1, 2]"
  end

  it "does not call #to_s on a String returned from #inspect" do
    str = "abc"
    str.should_not_receive(:to_s)

    @subject.new([str]).send(@method).should == '["abc"]'
  end

  it "calls #to_s on the object returned from #inspect if the Object isn't a String" do
    obj = mock("Array#inspect/to_s calls #to_s")
    obj.should_receive(:inspect).and_return(obj)
    obj.should_receive(:to_s).and_return("abc")

    @subject.new([obj]).send(@method).should == "[abc]"
  end

  it "does not call #to_str on the object returned from #inspect when it is not a String" do
    obj = mock("Array#inspect/to_s does not call #to_str")
    obj.should_receive(:inspect).and_return(obj)
    obj.should_not_receive(:to_str)

    @subject.new([obj]).send(@method).should =~ /^\[#<MockObject:0x[0-9a-f]+>\]$/
  end

  it "does not call #to_str on the object returned from #to_s when it is not a String" do
    obj = mock("Array#inspect/to_s does not call #to_str on #to_s result")
    obj.should_receive(:inspect).and_return(obj)
    obj.should_receive(:to_s).and_return(obj)
    obj.should_not_receive(:to_str)

    @subject.new([obj]).send(@method).should =~ /^\[#<MockObject:0x[0-9a-f]+>\]$/
  end

  it "does not swallow exceptions raised by #to_s" do
    obj = mock("Array#inspect/to_s does not swallow #to_s exceptions")
    obj.should_receive(:inspect).and_return(obj)
    obj.should_receive(:to_s).and_raise(Exception)

    -> { @subject.new([obj]).send(@method) }.should raise_error(Exception)
  end

  it "represents a recursive element with '[...]'" do
    CollectionSpecs.recursive_array(@subject).send(@method).should == "[1, \"two\", 3.0, [...], [...], [...], [...], [...]]"
    CollectionSpecs.head_recursive_array(@subject).send(@method).should == "[[...], [...], [...], [...], [...], 1, \"two\", 3.0]"
    CollectionSpecs.empty_recursive_array(@subject).send(@method).should == "[[...]]"
  end

  ruby_version_is ''...'2.7' do
    it "taints the result if the Array is non-empty and tainted" do
      @subject.new([1, 2]).taint.send(@method).tainted?.should be_true
    end

    it "does not taint the result if the Array is tainted but empty" do
      @subject.new([]).taint.send(@method).tainted?.should be_false
    end

    it "taints the result if an element is tainted" do
      @subject.new(["str".taint]).send(@method).tainted?.should be_true
    end

    it "untrusts the result if the Array is untrusted" do
      @subject.new([1, 2]).untrust.send(@method).untrusted?.should be_true
    end

    it "does not untrust the result if the Array is untrusted but empty" do
      @subject.new([]).untrust.send(@method).untrusted?.should be_false
    end

    it "untrusts the result if an element is untrusted" do
      @subject.new(["str".untrust]).send(@method).untrusted?.should be_true
    end
  end

  describe "with encoding" do
    before :each do
      @default_external_encoding = Encoding.default_external
    end

    after :each do
      Encoding.default_external = @default_external_encoding
    end

    it "returns a US-ASCII string for an empty Array" do
      @subject.new([]).send(@method).encoding.should == Encoding::US_ASCII
    end

    it "use the default external encoding if it is ascii compatible" do
      Encoding.default_external = Encoding.find('UTF-8')

      utf8 = "utf8".encode("UTF-8")
      jp   = "jp".encode("EUC-JP")
      array = [jp, utf8]

      @subject.new(array).send(@method).encoding.name.should == "UTF-8"
    end

    it "use US-ASCII encoding if the default external encoding is not ascii compatible" do
      Encoding.default_external = Encoding.find('UTF-32')

      utf8 = "utf8".encode("UTF-8")
      jp   = "jp".encode("EUC-JP")
      array = [jp, utf8]

      @subject.new(array).send(@method).encoding.name.should == "US-ASCII"
    end

    it "does not raise if inspected result is not default external encoding" do
      utf_16be = mock("utf_16be")
      utf_16be.should_receive(:inspect).and_return(%<"utf_16be \u3042">.encode!(Encoding::UTF_16BE))

      @subject.new([utf_16be]).send(@method).should == '["utf_16be \u3042"]'
    end
  end
end
