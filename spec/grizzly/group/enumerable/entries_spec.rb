require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/entries'

describe "Enumerable#entries" do
  it_behaves_like :enumerable_entries , :entries

  # New Interface
  it "doesn't return a subclass instance on Array subclasses" do
    Group.new([1,2,3,4]).entries.should be_an_instance_of(Array)
  end
end
