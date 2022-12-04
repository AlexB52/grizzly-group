require_relative '../../spec_helper'

describe "Array#slice!" do
  describe "with a subclass of Array" do
    before :each do
      @array = MyCollection[1, 2, 3, 4, 5]
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance with [n, m]" do
        @array.slice!(0, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n, m]" do
        @array.slice!(-3, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n..m]" do
        @array.slice!(1..3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n...m]" do
        @array.slice!(1...3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n..-m]" do
        @array.slice!(-3..-1).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n...-m]" do
        @array.slice!(-3...-1).should be_an_instance_of(MyCollection)
      end
    end

    # core/array/slice_spec.rb:217
    # core/array/slice_spec.rb:221
    # core/array/slice_spec.rb:225
    # core/array/slice_spec.rb:229
    # core/array/slice_spec.rb:233
    # core/array/slice_spec.rb:237
    ruby_version_is '3.0' do
      it "returns a subclass instance with [n, m]" do
        @array.slice!(0, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n, m]" do
        @array.slice!(-3, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n..m]" do
        @array.slice!(1..3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n...m]" do
        @array.slice!(1...3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n..-m]" do
        @array.slice!(-3..-1).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n...-m]" do
        @array.slice!(-3...-1).should be_an_instance_of(MyCollection)
      end
    end
  end
end
