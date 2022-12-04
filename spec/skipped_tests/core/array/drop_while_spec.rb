require_relative '../../spec_helper'

describe "Array#drop_while" do
  ruby_version_is ''...'3.0' do
    it 'returns a subclass instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].drop_while { |n| n < 4 }.should be_an_instance_of(MyCollection)
    end
  end

  ruby_version_is '3.0' do
    it 'returns a Array instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].drop_while { |n| n < 4 }.should be_an_instance_of(MyCollection)
    end
  end
end
