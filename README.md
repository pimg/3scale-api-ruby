# ThreeScale::API


This gem aims to expose all [3scale](http://3scale.net) APIs with a Ruby interface.


## Installation

Add this line to your application's Gemfile:

```ruby
gem '3scale-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install 3scale-api

## Usage


```ruby
require '3scale/api'
client = ThreeScale::API.new(admin_domain: 'foo-admin.3scale.net', provider_key: 'foobar')

services = client.list_services

## Design

Design decisions:

* 0 runtime dependencies
* thread safety
* tested

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To run tests run `rake` or `rspec`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/3scale/3scale-api-ruby.

