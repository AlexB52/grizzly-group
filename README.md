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

marks = MarkCollection.new (0..100).to_a.map { |i| Mark.new(i) }

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
- [ ] MVP: Enumerable methods
- [ ] [Enumerators](https://github.com/AlexB52/grizzly-rb/issues/1)
- [ ] [Lazy Enumerators](https://github.com/AlexB52/grizzly-rb/issues/2)

## Benchmark

TODO

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
