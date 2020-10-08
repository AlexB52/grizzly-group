describe :enumeratorize, shared: true do
  it "returns an Enumerator if no block given" do
    klass = if @subject == Array
      Enumerator
    elsif @subject == Grizzly::Group
      Grizzly::Enumerator
    else
      raise 'no expected subject to check on'
    end

    @subject.new([1,2]).send(@method).should be_an_instance_of(klass)
  end
end
