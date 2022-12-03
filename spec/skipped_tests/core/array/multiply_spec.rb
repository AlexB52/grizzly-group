require_relative '../../spec_helper'

describe "Array#* with an integer" do
  # core/array/multiply_spec.rb:6
  it "tries to convert the passed argument to a String using #to_str" do
    obj = mock('separator')
    obj.should_receive(:to_str).and_return('::')
    (Grizzly::Collection.new([1, 2, 3, 4]) * obj).should == '1::2::3::4'
  end

  # core/array/multiply_spec.rb:23
  it "converts the passed argument to a String rather than an Integer" do
    obj = mock('2')
    def obj.to_int() 2 end
    def obj.to_str() "2" end
    (Grizzly::Collection.new([:a, :b, :c]) * obj).should == "a2b2c"
  end

  describe "with a subclass of Array" do
    before :each do
      @array = MyCollection[1, 2, 3, 4, 5]
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance" do
        (@array * 0).should be_an_instance_of(MyCollection)
        (@array * 1).should be_an_instance_of(MyCollection)
        (@array * 2).should be_an_instance_of(MyCollection)
      end
    end

    # core/array/multiply_spec.rb:88
    ruby_version_is '3.0' do
      it "returns an Array instance" do
        (@array * 0).should be_an_instance_of(MyCollection)
        (@array * 1).should be_an_instance_of(MyCollection)
        (@array * 2).should be_an_instance_of(MyCollection)
      end
    end
  end
end
