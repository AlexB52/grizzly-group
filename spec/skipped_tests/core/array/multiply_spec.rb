require_relative '../../spec_helper'

describe "Array#* with an integer" do
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
