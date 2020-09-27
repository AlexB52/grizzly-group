# Grizzly::Group

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/grizzly/group`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grizzly-group'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install grizzly-group

## Usage


```ruby
User = Struct.new(:age)

users = (0..10).to_a.map { |i| User.new(i) }

class UserGroup < Grizzly::Group
  def average_age
    sum(&:age) / size.to_f
  end
end

UserGroup.new(users).
  select { |user| user.age.even? }.
  reject { |user| user.age < 3 }.
  average_age
# => 7.0

users.
  select { |user| user.age.even? }.
  reject { |user| user.age < 3 }.
  average_age
# NoMethodError (undefined method `average_age' for #<Array:0x00007f955e8cb248>)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/grizzly-group.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
