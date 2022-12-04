require_relative '../../spec_helper'

describe 'Arrat#slice' do
  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear

      @array = MyCollection[1, 2, 3, 4, 5]
    end

    it "returns the element even if it's an array when one integer is passed" do
      array = MyCollection[[1], [2], [3]]
      array.send(:slice, 0).should be_an_instance_of(Array)

      a = 1
      array.send(:slice, a).should be_an_instance_of(Array)
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance with [n, m]" do
        @array.send(:slice, 0, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n, m]" do
        @array.send(:slice, -3, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n..m]" do
        @array.send(:slice, 1..3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n...m]" do
        @array.send(:slice, 1...3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n..-m]" do
        @array.send(:slice, -3..-1).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n...-m]" do
        @array.send(:slice, -3...-1).should be_an_instance_of(MyCollection)
      end
    end

    ruby_version_is '3.0' do
      # core/array/shared/slice.rb:427
      it "returns a Array instance with [n, m]" do
        @array.send(:slice, 0, 2).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:431
      it "returns a Array instance with [-n, m]" do
        @array.send(:slice, -3, 2).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:439
      it "returns a Array instance with [n..m]" do
        @array.send(:slice, 1..3).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:435
      it "returns a Array instance with [n...m]" do
        @array.send(:slice, 1...3).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:443
      it "returns a Array instance with [-n..-m]" do
        @array.send(:slice, -3..-1).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:447
      it "returns a Array instance with [-n...-m]" do
        @array.send(:slice, -3...-1).should be_an_instance_of(MyCollection)
      end
    end
  end
end

describe 'Arrat#[]' do
  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear

      @array = MyCollection[1, 2, 3, 4, 5]
    end

    it "returns the element even if it's an array when one integer is passed" do
      array = MyCollection[[1], [2], [3]]
      array.send(:[], 0).should be_an_instance_of(Array)

      a = 1
      array.send(:[], a).should be_an_instance_of(Array)
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance with [n, m]" do
        @array.send(:[], 0, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n, m]" do
        @array.send(:[], -3, 2).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n..m]" do
        @array.send(:[], 1..3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [n...m]" do
        @array.send(:[], 1...3).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n..-m]" do
        @array.send(:[], -3..-1).should be_an_instance_of(MyCollection)
      end

      it "returns a subclass instance with [-n...-m]" do
        @array.send(:[], -3...-1).should be_an_instance_of(MyCollection)
      end
    end

    ruby_version_is '3.0' do
      # core/array/shared/slice.rb:427
      it "returns a Array instance with [n, m]" do
        @array.send(:[], 0, 2).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:431
      it "returns a Array instance with [-n, m]" do
        @array.send(:[], -3, 2).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:439
      it "returns a Array instance with [n..m]" do
        @array.send(:[], 1..3).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:435
      it "returns a Array instance with [n...m]" do
        @array.send(:[], 1...3).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:443
      it "returns a Array instance with [-n..-m]" do
        @array.send(:[], -3..-1).should be_an_instance_of(MyCollection)
      end

      # core/array/shared/slice.rb:447
      it "returns a Array instance with [-n...-m]" do
        @array.send(:[], -3...-1).should be_an_instance_of(MyCollection)
      end
    end
  end
end
