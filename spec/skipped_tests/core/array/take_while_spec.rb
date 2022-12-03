require_relative '../../spec_helper'

describe "Array#take_while" do
  ruby_version_is ''...'3.0' do
    it 'returns a subclass instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].take_while { |n| n < 4 }.should be_an_instance_of(MyCollection)
    end
  end

  # core/array/take_while_spec.rb:24
  ruby_version_is '3.0' do
    it 'returns a Array instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].take_while { |n| n < 4 }.should be_an_instance_of(MyCollection)
    end
  end
end
