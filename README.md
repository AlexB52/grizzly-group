:construction: **The gem is not published and is still a work in progress.**

# Grizzly::Collection

Grizzly::Collection is an attempt to end the predominance of the Array in Ruby by providing a Ruby monad & collection class that behaves like an array but returns a subclass instance instead of a new array.

The work came after reading [Steve Klabnik's warning](https://steveklabnik.com/writing/beware-subclassing-ruby-core-classes) & [gist](https://gist.github.com/steveklabnik/6071687) about subclassing Ruby core classes. This is an attempt to solve what is intuitively expected from sugrouping methods like `Array#select, Array#partition, Array#reject` to name a few.

The library is tested against [ruby/spec](https://github.com/ruby/spec) to avoid undesirable side effects. The Grizzly::Collection class works and is subclassed from Array, you will love to hate it. 

Other libraries that provide something similar: [Dry::Monads::List](https://dry-rb.org/gems/dry-monads/1.3/list/)

## Usage

```ruby
require "grizzly"

Mark = Struct.new(:score)

class MarkCollection < Grizzly::Collection
  def average_score
    sum(&:score) / size.to_f
  end
end

marks_array = (0..100).to_a.map { |i| Mark.new(i) }

marks = MarkCollection.new(marks_array)

marks.select { |mark| mark.score.even? }.
      average_score

# => 50.0

marks.select { |mark| mark.score.even? }.
      reject { |mark| mark.score <= 80 }.
      average_score

# => 91.0
```

## Ruby support

Ruby 2.7+

## Roadmap

- [X] MVP: Array methods
- [X] MPV: Enumerators methods
- [X] Benchmarks
- [X] [Lazy Enumerators](https://github.com/AlexB52/grizzly-rb/issues/2)

## Benchmark

You can run the benchmark with `ruby benchmark.rb`

The benchmark runs over increments of list with 10n+1 items for a total of 5_000_000 iterations.

### Conclusions

This library initialize a new collection everytime the Array method returns.

Chaining methods with Grizzly::Collection is:
  * really expensive for list with a small number of items. <= 10
  * less of a problem with lists over 100 items.

### Raw Results
```
=== One method ===
{ |list| list.select(&:odd?) }

                                                                             user     system      total        real
List of length 1 iterated over 5000000 times - Array                     1.465777   0.010639   1.476416 (  1.484419)
List of length 1 iterated over 5000000 times - Grizzly::Collection       4.173212   0.025837   4.199049 (  4.219159)

                                                                             user     system      total        real
List of length 10 iterated over 500000 times - Array                     0.449475   0.002248   0.451723 (  0.453940)
List of length 10 iterated over 500000 times - Grizzly::Collection       0.848438   0.006855   0.855293 (  0.858316)

                                                                             user     system      total        real
List of length 100 iterated over 50000 times - Array                     0.342236   0.003515   0.345751 (  0.347207)
List of length 100 iterated over 50000 times - Grizzly::Collection       0.389331   0.005771   0.395102 (  0.396907)

                                                                             user     system      total        real
List of length 1000 iterated over 5000 times - Array                     0.367041   0.013971   0.381012 (  0.384799)
List of length 1000 iterated over 5000 times - Grizzly::Collection       0.338568   0.007703   0.346271 (  0.347265)

                                                                             user     system      total        real
List of length 10000 iterated over 500 times - Array                     0.332582   0.008056   0.340638 (  0.341963)
List of length 10000 iterated over 500 times - Grizzly::Collection       0.338311   0.016007   0.354318 (  0.356256)


=== Two chained methods ===
{ |list| list.select(&:odd?).reject(&:odd?) }

                                                                             user     system      total        real
List of length 1 iterated over 5000000 times - Array                     2.087311   0.016413   2.103724 (  2.114187)
List of length 1 iterated over 5000000 times - Grizzly::Collection       8.177386   0.051953   8.229339 (  8.265598)

                                                                             user     system      total        real
List of length 10 iterated over 500000 times - Array                     0.649130   0.002928   0.652058 (  0.654708)
List of length 10 iterated over 500000 times - Grizzly::Collection       1.408604   0.009925   1.418529 (  1.424733)

                                                                             user     system      total        real
List of length 100 iterated over 50000 times - Array                     0.503027   0.001814   0.504841 (  0.506741)
List of length 100 iterated over 50000 times - Grizzly::Collection       0.623167   0.005466   0.628633 (  0.632303)

                                                                             user     system      total        real
List of length 1000 iterated over 5000 times - Array                     0.486371   0.003466   0.489837 (  0.491048)
List of length 1000 iterated over 5000 times - Grizzly::Collection       0.500942   0.005642   0.506584 (  0.509051)

                                                                             user     system      total        real
List of length 10000 iterated over 500 times - Array                     0.492759   0.008542   0.501301 (  0.503459)
List of length 10000 iterated over 500 times - Grizzly::Collection       0.514448   0.014804   0.529252 (  0.531968)


=== Chained enumerators ===
{ |list| list.select.each.select.reject(&:odd?) }

                                                                             user     system      total        real
List of length 1 iterated over 5000000 times - Array                     5.537677   0.066783   5.604460 (  5.630154)
List of length 1 iterated over 5000000 times - Grizzly::Collection      30.203623   0.230334  30.433957 ( 30.573476)

                                                                             user     system      total        real
List of length 10 iterated over 500000 times - Array                     1.060200   0.008406   1.068606 (  1.073304)
List of length 10 iterated over 500000 times - Grizzly::Collection       3.674943   0.029664   3.704607 (  3.721847)

                                                                             user     system      total        real
List of length 100 iterated over 50000 times - Array                     0.570368   0.003019   0.573387 (  0.575771)
List of length 100 iterated over 50000 times - Grizzly::Collection       0.895747   0.005782   0.901529 (  0.906251)

                                                                             user     system      total        real
List of length 1000 iterated over 5000 times - Array                     0.518924   0.003155   0.522079 (  0.524788)
List of length 1000 iterated over 5000 times - Grizzly::Collection       0.553667   0.004346   0.558013 (  0.560381)

                                                                             user     system      total        real
List of length 10000 iterated over 500 times - Array                     0.518883   0.010600   0.529483 (  0.531777)
List of length 10000 iterated over 500 times - Grizzly::Collection       0.528470   0.014786   0.543256 (  0.545524)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grizzly-rb', require: 'grizzly'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install grizzly-rb

## Development

```bash
# Setup dependencies: bundler, mspec and ruby-spec
$ bin/setup

# Run all specs
$ bin/test
```

### Prototype with console

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/grizzly-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
