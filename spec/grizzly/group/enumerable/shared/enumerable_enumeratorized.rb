require_relative 'enumeratorized'

# describe :enumerable_enumeratorized_with_unknown_size, shared: true do
#   before { @subject ||= nil }

#   describe "Enumerable with size" do
#     before :all do
#       numerous = EnumerableSpecs::NumerousWithSize.new(1, 2, 3, 4)
#       @object = @subject&.new(numerous) || numerous
#     end
#     it_should_behave_like :enumeratorized_with_unknown_size
#   end

#   describe "Enumerable with no size" do
#     before :all do
#       numerous = EnumerableSpecs::Numerous.new(1, 2, 3, 4)
#       @object = @subject&.new(numerous) || numerous
#     end
#     it_should_behave_like :enumeratorized_with_unknown_size
#   end
# end

# describe :enumerable_enumeratorized_with_origin_size, shared: true do
  # before { @subject ||= nil }

  # describe "Enumerable with size" do
  #   before :all do
  #     numerous = EnumerableSpecs::NumerousWithSize.new(1, 2, 3, 4)
  #     @object = @subject&.new(numerous) || numerous
  #   end
  #   it_should_behave_like :enumeratorized_with_origin_size
  # end

  # describe "Enumerable with no size" do
  #   before :all do
  #     numerous = EnumerableSpecs::Numerous.new(1, 2, 3, 4)
  #     @object = @subject&.new(numerous) || numerous
  #   end
  #   it_should_behave_like :enumeratorized_with_unknown_size
  # end
# end
