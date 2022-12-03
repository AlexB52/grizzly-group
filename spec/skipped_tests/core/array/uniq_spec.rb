require_relative '../../spec_helper'

describe "Array#uniq" do
  ruby_version_is ''...'3.0' do
    it "returns subclass instance on Array subclasses" do
      MyCollection[1, 2, 3].uniq.should be_an_instance_of(MyCollection)
    end
  end

  # core/array/uniq_spec.rb:94
  ruby_version_is '3.0' do
    it "returns Array instance on Array subclasses" do
      MyCollection[1, 2, 3].uniq.should be_an_instance_of(MyCollection)
    end
  end
end
