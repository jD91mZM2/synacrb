# synacrb

This is a Ruby library for synac.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'synacrb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install synacrb

## Usage

Example:  
```Ruby
session = Synacrb::Session.new "<address>", "<certificate hash>"
session.login_with_token true, "<username>", "<token>" # true indicates bot account

# First message should be LoginSuccess or an error
result = session.read
# TODO: Use result

# Initiate state
state = Synacrb::State.new

# Main loop
loop do
    packet = session.read
    state.update packet
    # TODO: Use packet
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jD91mZM2/synacrb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
