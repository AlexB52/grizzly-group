require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/push'


describe "Array#push" do
  before { @subject = Array }

  it_behaves_like :array_push, :push

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(Array)
  end
end

describe "Collection#push" do
  before { @subject = Group }

  it_behaves_like :array_push, :push

  it "returns a subclass instance of Array" do
    @subject.new([]).push(:last).should be_an_instance_of(@subject)
  end
end
