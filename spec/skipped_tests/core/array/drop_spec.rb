require_relative '../../spec_helper'

describe "Array#drop" do
  ruby_version_is ''...'3.0' do
    it 'returns a subclass instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].drop(1).should be_an_instance_of(MyCollection)
    end
  end

  ruby_version_is '3.0' do
    it 'returns a Array instance for Array subclasses' do
      MyCollection[1, 2, 3, 4, 5].drop(1).should be_an_instance_of(MyCollection)
    end
  end
end
