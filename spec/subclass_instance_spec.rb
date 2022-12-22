require_relative './spec_helper'

# ::[]
# ::new
# ::try_convert

describe 'Array methods returned subclasses of arrays or other' do
  it '#&' do
    a = MyCollection[0, 1, 2, 3] & MyCollection[1, 2]
    a.should be_an_instance_of(MyCollection)
  end

  it '#*' do
    a = MyCollection['x', 'y']
    (a * 3).should be_an_instance_of(MyCollection)
    (a * ',').should be_an_instance_of(String)
  end

  it '#+' do
    a = MyCollection[0, 1] + MyCollection[2, 3]
    a.should be_an_instance_of(MyCollection)
  end

  it '#-' do
    a = MyCollection[0, 1, 2] - MyCollection[4]
    a.should be_an_instance_of(MyCollection)
  end

  it '#<<' do
    a = MyCollection[:foo, 'bar', 2]
    (a << :baz).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  # #<=> ignored
  # signature: array <=> other_array → -1, 0, or 1

  # #== ignored
  # signature: array == other_array → true or false

  it '#[]' do
    a = MyCollection[:foo, 'bar', 2]
    a[0, 2].should be_an_instance_of(MyCollection)
    a[0..2].should be_an_instance_of(MyCollection)
  end

  it '#[]=' do
    a = MyCollection[:foo, 'bar', 2]
    a[1..0] = 'foo'
    a.should be_an_instance_of(MyCollection)
  end

  # #all? ignored because signature:
    # all? → true or false
    # all? {|element| ... } → true or false
    # all?(obj) → true or false

  # #any? ignored because signature:
    # any? → true or false
    # any? {|element| ... } → true or false
    # any?(obj) → true or false

  it '#append' do
    a = MyCollection[:foo, 'bar', 2]
    a.append(:baz, :bat).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#assoc' do
    a = MyCollection[{foo: 0}, [2, 4], [4, 5, 6], [4, 5]]
    a.assoc(4).should_not be_an_instance_of(MyCollection)
  end

  # #at ignored because signature:
    # at(index) → object

  # #bsearch ignored because signature:
    # bsearch {|element| ... } → object
    # bsearch → new_enumerator

  #bsearch_index ignored because signature:
    # bsearch_index {|element| ... } → integer or nil
    # bsearch_index → new_enumerator

  it '#clear' do
    a = MyCollection[:foo, 'bar', 2]
    a.clear.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#collect' do
    a = MyCollection[:foo, 'bar', 2]
    a1 = a.collect {|element| element.class }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#collect!' do
    a = MyCollection[:foo, 'bar', 2]
    a1 = a.collect! {|element| element.class }
    a1.should be_an_instance_of(MyCollection)
  end

  # #combination ignored because signature:
    # combination(n) {|element| ... } → self
    # combination(n) → new_enumerator

  it '#compact' do
    a = MyCollection[nil, 0, nil, 1, nil, 2, nil]
    a.compact.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#compact!' do
    a = MyCollection[nil, 0, nil, 1, nil, 2, nil]
    a.compact!.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#concat' do
    a = MyCollection[0, 1]
    a.concat([2, 3], [4, 5]).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  # #count ignored because signature:
    # count → an_integer
    # count(obj) → an_integer
    # count {|element| ... } → an_integer

  # #cycle ignored because signature:
    # cycle {|element| ... } → nil
    # cycle(count) {|element| ... } → nil
    # cycle → new_enumerator
    # cycle(count) → new_enumerator

  # #deconstruct ignored because ? https://ruby-doc.org/3.2.0.rc1/Array.html#method-i-deconstruct

  it '#delete' do
    s1 = 'bar'; s2 = 'bar'
    a = MyCollection[:foo, s1, 2, s2]
    a.delete('bar')
    a.should be_an_instance_of(MyCollection)
  end

  it '#delete_at' do
    a = MyCollection[:foo, 'bar', 2]
    a.delete_at(1)
    a.should be_an_instance_of(MyCollection)
  end

  it '#delete_if' do
    a = MyCollection[:foo, 'bar', 2, 'bat']
    a.delete_if {|element| element.to_s.start_with?('b') } # => [:foo, 2]
    a.should be_an_instance_of(MyCollection)
  end

  it '#difference' do
    MyCollection[0, 1, 1, 2, 1, 1, 3, 1, 1].difference([1]).should be_an_instance_of(MyCollection)
    MyCollection[0, 1, 2, 3].difference([3, 0], [1, 3]).should be_an_instance_of(MyCollection)
    MyCollection[0, 1, 2].difference([4]).should be_an_instance_of(MyCollection)
  end

  it '#dig' do
    a = MyCollection[:foo, [:bar, :baz, [:bat, :bam]]]
    a.dig(1).should_not be_an_instance_of(MyCollection)       # => [:bar, :baz, [:bat, :bam]]
    a.dig(1, 2).should_not be_an_instance_of(MyCollection)    # => [:bat, :bam]
    a.dig(1, 2, 0).should_not be_an_instance_of(MyCollection) # => :bat
    a.dig(1, 2, 3).should_not be_an_instance_of(MyCollection) # => nil
  end

  it '#drop' do
    a = MyCollection[0, 1, 2, 3, 4, 5]
    a.drop(0).should be_an_instance_of(MyCollection) # => [0, 1, 2, 3, 4, 5]
    a.drop(1).should be_an_instance_of(MyCollection) # => [1, 2, 3, 4, 5]
    a.drop(2).should be_an_instance_of(MyCollection) # => [2, 3, 4, 5]
  end

  it '#drop_while' do
    a = MyCollection[0, 1, 2, 3, 4, 5]
    result = a.drop_while {|element| element < 3 } # => [3, 4, 5]

    result.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  # #each ignored because signature:
    # each {|element| ... } → self
    # each → Enumerator

  # #each_index ignored because signature:
    # each_index {|index| ... } → self
    # each_index → Enumerator

  # #empty? ignored because signature:
    # empty? → true or false

  # #eql? ignored because signature:
    # eql? other_array → true or false

  # #fetch ignored because signature:
    # fetch(index) → element
    # fetch(index, default_value) → element
    # fetch(index) {|index| ... } → element

  it '#fill' do
    # TODO: spec the other argument combination
    a = MyCollection['a', 'b', 'c', 'd']
    result = a.fill(:X)
    result.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#filter' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a1 = a.filter {|element| element.to_s.start_with?('b') }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#filter!' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a.filter! {|element| element.to_s.start_with?('b') }.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  # #find_index ignored because signature:
    # find_index -> new_enumerator

  it '#first' do
    a = MyCollection[:foo, 'bar', 2]
    a.first(2).should be_an_instance_of(MyCollection)
  end

  it '#flatten' do
    a = MyCollection[ 0, [ 1, [2, 3], 4 ], 5 ]
    a.flatten(0).should be_an_instance_of(MyCollection)
    a.flatten.should be_an_instance_of(MyCollection)
  end

  it '#flatten!' do
    a = MyCollection[ 0, [ 1, [2, 3], 4 ], 5 ]
    a.flatten!(1)
    a.should be_an_instance_of(MyCollection)

    b = MyCollection[ 0, [ 1, [2, 3], 4 ], 5 ]
    b.flatten!
    b.should be_an_instance_of(MyCollection)
  end

  # #hash ignored because signature:
    # hash → integer

  # #include? ignored because signature:
    # include?(obj) → true or false

  # #index ignored becuase signature:
    # index(object) → integer or nil
    # index {|element| ... } → integer or nil
    # index → new_enumerator

  it '#initialize_copy' do
    # method is private
    a = MyCollection[:foo, 'bar', 2]
    a.send(:initialize_copy, ['foo', :bar, 3]).should be_an_instance_of(MyCollection) # => ["foo", :bar, 3]
  end

  it '#insert' do
    a = MyCollection[:foo, 'bar', 2]
    a.insert(1, :bat, :bam).should be_an_instance_of(MyCollection) # => [:foo, :bat, :bam, "bar", 2]
  end

  # #inspect ignored because signature:
    # inspect → new_string

  # #intersect? ignorder because signature:
    # intersect?(other_ary) → true or false

  it '#intersection' do
    MyCollection[0, 1, 2, 3].intersection([0, 1, 2], [0, 1, 3]).should be_an_instance_of(MyCollection) # => [0, 1]
    MyCollection[0, 0, 1, 1, 2, 3].intersection([0, 1, 2], [0, 1, 3]).should be_an_instance_of(MyCollection) # => [0, 1]
  end

  # #join ignored because signature:
    # join →new_string
    # join(separator = $,) → new_string

  it '#keep_if' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a.keep_if {|element| element.to_s.start_with?('b') }.should be_an_instance_of(MyCollection) # => ["bar", :bam]
  end

  it '#last' do
    a = MyCollection[:foo, 'bar', 2]
    a.last(2).should be_an_instance_of(MyCollection) # => ["bar", 2]
  end

  # #length ignored because signature:
    # length → an_integer

  it '#map' do
    a = MyCollection[:foo, 'bar', 2]
    a1 = a.map {|element| element.class }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#collect!' do
    a = MyCollection[:foo, 'bar', 2]
    a1 = a.map! {|element| element.class }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#max' do
    MyCollection[0, 1, 2, 3].max(3).should be_an_instance_of(MyCollection) # => [3, 2, 1]
    MyCollection[0, 1, 2, 3].max(6).should be_an_instance_of(MyCollection) # => [3, 2, 1, 0]
  end

  it '#min' do
    MyCollection[0, 1, 2, 3].min(3).should be_an_instance_of(MyCollection) # => [0, 1, 2]
    MyCollection[0, 1, 2, 3].min(6).should be_an_instance_of(MyCollection) # => [0, 1, 2, 3]
  end

  it '#minmax' do
    MyCollection[0, 1, 2].minmax.should be_an_instance_of(MyCollection) # => [0, 2]
    MyCollection['0', '00', '000'].minmax {|a, b| a.size <=> b.size }.should be_an_instance_of(MyCollection) # => ["0", "000"]
  end

  # #none? ignored because signature:
    # none? → true or false
    # none? {|element| ... } → true or false
    # none?(obj) → true or false

  # #one? ignored because signature:
    # one? → true or falseclick to toggle source
    # one? {|element| ... } → true or false
    # one?(obj) → true or false

  # #pack ignored because not implemented

  # #permutation ignored because signature:
    # permutation {|element| ... } → self
    # permutation(n) {|element| ... } → self
    # permutation → new_enumerator
    # permutation(n) → new_enumerator

  it '#pop' do
    a = MyCollection[:foo, 'bar', 2]
    a.pop.should_not be_an_instance_of(MyCollection)
    a.pop(2).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#prepend' do
    a = MyCollection[:foo, 'bar', 2]
    a.prepend(:baz, :bat).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#product' do
    a = MyCollection[0, 1, 2]
    a1 = [3, 4]
    a2 = [5, 6]

    result = a.product(a1, a2)
    result.should_not be_an_instance_of(MyCollection)
    result.all? { |product| product.should be_an_instance_of(MyCollection) } # => [[0, 3, 5], [0, 3, 6], [0, 4, 5], [0, 4, 6], [1, 3, 5], [1, 3, 6], [1, 4, 5], [1, 4, 6], [2, 3, 5], [2, 3, 6], [2, 4, 5], [2, 4, 6]]
  end

  it '#push' do
    a = MyCollection[:foo, 'bar', 2]
    a.push(:baz, :bat).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#rassoc' do
    a = [{foo: 0}, [2, 4], [4, 5, 6], [4, 5]]
    a.rassoc(4).should_not be_an_instance_of(MyCollection) # => [2, 4]
  end

  it '#reject' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a1 = a.reject {|element| element.to_s.start_with?('b') }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#reject!' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a.reject! {|element| element.to_s.start_with?('b') }.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  # #repeated_combination ignored because signature:
    # repeated_combination(n) {|combination| ... } → self
    # repeated_combination(n) → new_enumerator

  # #repeated_permutation ignored because signature:
    # repeated_permutation(n) {|permutation| ... } → self
    # repeated_permutation(n) → new_enumerator

  it '#replace' do
    # method is private
    a = MyCollection[:foo, 'bar', 2]
    a.replace(['foo', :bar, 3]).should be_an_instance_of(MyCollection) # => ["foo", :bar, 3]
  end

  it '#reverse' do
    a = MyCollection['foo', 'bar', 'two']
    a.reverse.should be_an_instance_of(MyCollection)
  end

  it '#reverse!' do
    a = MyCollection['foo', 'bar', 'two']
    a.reverse!
    a.should be_an_instance_of(MyCollection)
  end

  # #reverse_each ignored because signature:
    # reverse_each {|element| ... } → self
    # reverse_each → Enumerator

  # #rindex ignored because signature:
    # rindex(object) → integer or nil
    # rindex {|element| ... } → integer or nil
    # rindex → new_enumerator

  it '#rotate' do
    a = MyCollection[:foo, 'bar', 2, 'bar']
    a.rotate.should be_an_instance_of(MyCollection)
  end

  it '#rotate!' do
    a = MyCollection[:foo, 'bar', 2, 'bar']
    a.rotate!
    a.should be_an_instance_of(MyCollection)
  end

  it '#sample' do
    a = MyCollection[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    a.sample.should_not be_an_instance_of(MyCollection)
    a.sample(3).should be_an_instance_of(MyCollection)
    a.sample(3, random: Random.new(1)).should be_an_instance_of(MyCollection)
  end

  it '#select' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a1 = a.select {|element| element.to_s.start_with?('b') }
    a1.should be_an_instance_of(MyCollection)
  end

  it '#select!' do
    a = MyCollection[:foo, 'bar', 2, :bam]
    a.select! {|element| element.to_s.start_with?('b') }.should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#shift' do
    a = MyCollection[:foo, 'bar', 2]
    a.shift.should_not be_an_instance_of(MyCollection)
    a.shift(2).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#shuffle' do
    a = MyCollection[1, 2, 3]
    a.shuffle.should be_an_instance_of(MyCollection)
    a.shuffle(random: Random.new(1)).should be_an_instance_of(MyCollection)
  end

  it '#shuffle!' do
    a = MyCollection[1, 2, 3]
    a.shuffle!
    a.shuffle!(random: Random.new(1))
    a.should be_an_instance_of(MyCollection)
  end

  # #size ignored because signature:
    # length → an_integer

  it '#slice' do
    a = MyCollection[:foo, 'bar', 2]
    a.slice(0)
    a.should be_an_instance_of(MyCollection)

    a.slice(0, 2).should be_an_instance_of(MyCollection)

    a.slice(0..1).should be_an_instance_of(MyCollection)
  end

  it '#slice!' do
    a = MyCollection[:foo, 'bar', 2]
    a.slice!(0)
    a.slice!(0, 2)
    a.slice!(0..1)
    a.should be_an_instance_of(MyCollection)
  end

  it '#sort' do
    a = MyCollection.new('abcde'.split('')).shuffle
    a.sort.should be_an_instance_of(MyCollection)
  end

  it '#sort!' do
    a = MyCollection.new('abcde'.split('')).shuffle
    a.sort!
    a.should be_an_instance_of(MyCollection)
  end

  it '#sort_by!' do
    a = MyCollection['aaaa', 'bbb', 'cc', 'd']
    a.sort_by! {|element| element.size }
    a.should be_an_instance_of(MyCollection)
  end

  # #sum ignored because signature:
    # sum(init = 0) → objectclick to toggle source
    # sum(init = 0) {|element| ... } → object

  it '#take' do
    a = MyCollection[0, 1, 2, 3, 4, 5]
    a.take(1).should be_an_instance_of(MyCollection)
    a.take(2).should be_an_instance_of(MyCollection)
    a.take(50).should be_an_instance_of(MyCollection)
  end

  it '#take_while' do
    a = MyCollection[0, 1, 2, 3, 4, 5]
    a.take_while {|element| element < 3 }.should be_an_instance_of(MyCollection)
    a.take_while {|element| true }.should be_an_instance_of(MyCollection)
  end

  it '#to_a' do
    a = MyCollection[:foo, 'bar', 2]
    a.to_a.should be_an_instance_of(Array)
  end

  it '#to_ary' do
    a = MyCollection[:foo, 'bar', 2]
    a.to_ary.should be_an_instance_of(MyCollection)
  end

  # #to_h ignored because signature:
    # to_h → new_hash
    # to_h {|item| ... } → new_hash

  # #to_s ignored because signature:
    # to_s → new_string

  it '#transpose' do
    a = MyCollection[[:a0, :a1], [:b0, :b1], [:c0, :c1]]
    a.transpose.should be_an_instance_of(MyCollection)
  end

  it '#union' do
    MyCollection[0, 1, 2, 3].union([4, 5], [6, 7]).should be_an_instance_of(MyCollection)
    MyCollection[0, 1, 1].union([2, 1], [3, 1]).should be_an_instance_of(MyCollection)
    MyCollection[0, 1, 2, 3].union([3, 2], [1, 0]).should be_an_instance_of(MyCollection)
  end

  it '#uniq' do
    a = MyCollection[0, 0, 1, 1, 2, 2]
    a.uniq.should be_an_instance_of(MyCollection)
  end

  it '#uniq!' do
    a = MyCollection[0, 0, 1, 1, 2, 2]
    a.uniq!
    a.should be_an_instance_of(MyCollection)
  end

  it '#unshift' do
    a = MyCollection[:foo, 'bar', 2]
    a.unshift(:baz, :bat).should be_an_instance_of(MyCollection)
    a.should be_an_instance_of(MyCollection)
  end

  it '#values_at' do
    a = MyCollection[:foo, 'bar', 2]
    a.values_at(0, 2).should be_an_instance_of(MyCollection)
    a.values_at(0..1).should be_an_instance_of(MyCollection)
  end

  it '#zip' do
    a = MyCollection[:a0, :a1, :a2, :a3]
    b = MyCollection[:b0, :b1, :b2, :b3]
    c = MyCollection[:c0, :c1, :c2, :c3]
    d = a.zip(b, c)
    d.should be_an_instance_of(Array)
    d.all? { |zip| zip.should be_an_instance_of(MyCollection) }
  end

  it '#|' do
    result = MyCollection[0, 1, 2, 3] | [4, 5] | [6, 7]
    result.should be_an_instance_of(MyCollection)

    result = MyCollection[0, 1, 1] | [2, 1] | [3, 1]
    result.should be_an_instance_of(MyCollection)

    result = MyCollection[0, 1, 2, 3] | [3, 2] | [1, 0]
    result.should be_an_instance_of(MyCollection)
  end
end
