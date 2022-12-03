:construction: **The gem is not published and is still a work in progress.**

# Grizzly::Collection

Grizzly::Collection is an attempt to end the predominance of the Array in Ruby by providing a Ruby monad & collection class that behaves like an array but returns a subclass instance instead of a new array.

The work came after reading [Steve Klabnik's warning](https://steveklabnik.com/writing/beware-subclassing-ruby-core-classes) & [gist](https://gist.github.com/steveklabnik/6071687) about subclassing Ruby core classes. This is an attempt to solve what is intuitively expected from sugrouping methods like `Array#select, Array#partition, Array#reject` to name a few.

The library is tested against [ruby/spec](https://github.com/ruby/spec) Array & Enumerable (soon to be tested against Enumerator) to avoid undesirable side effects. The Grizzly::Collection class works and is subclassed from Array, you will love to hate it.

Other examples of Monads & Collections: [Dry::Monads::List](https://dry-rb.org/gems/dry-monads/1.3/list/)

## Usage

```ruby
require 'grizzly-rb'

User = Struct.new(:age)
users = (0..10).to_a.map { |i| User.new(i) }

class UserGroup < Grizzly::Collection
  def average_age
    sum(&:age) / size.to_f
  end
end

group = UserGroup.new(users).
  select { |user| user.age.even? }.
  average_age
# => 5.0

UserGroup.new(users).
  select { |user| user.age.even? }.
  reject { |user| user.age < 3 }.
  average_age
# => 7.0
```

## Roadmap

- [X] [MVP - Modified Array Methods](https://github.com/AlexB52/grizzly-rb/issues/3)
- [ ] [Enumerators](https://github.com/AlexB52/grizzly-rb/issues/1)
- [ ] [Lazy Enumerators](https://github.com/AlexB52/grizzly-rb/issues/2)

### Returned Enumerator

### Lazy Enumerator

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grizzly-rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install grizzly-rb

## Development

```bash
# Setup dependencies
$ bin/setup

# Clone MSpec:
$ git clone https://github.com/ruby/mspec.git ../mspec

# Run rake spec & rake test
$ rake
```


You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/grizzly-rb.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
