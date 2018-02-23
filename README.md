# AllscriptsApi

[![Coverage Status](https://coveralls.io/repos/github/Avhana/allscripts_api/badge.svg?branch=master)](https://coveralls.io/github/Avhana/allscripts_api?branch=master)
[![Build Status](https://travis-ci.org/Avhana/allscripts_api.svg?branch=master)](https://travis-ci.org/Avhana/allscripts_api)
[![Dependency Status](https://gemnasium.com/badges/github.com/Avhana/allscripts_api.svg)](https://gemnasium.com/github.com/Avhana/allscripts_api)
[![Maintainability](https://api.codeclimate.com/v1/badges/9889f5255914a5fcbeb5/maintainability)](https://codeclimate.com/github/Avhana/allscripts_api/maintainability)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/allscripts_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'allscripts_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allscripts_api

## Configuration
```ruby
AllscriptsApi.configure do |config|
  config.app_name = 'YOUR_APP_NAME_HERE'
  config.app_username = 'YOUR_APP_USERNAME_HERE'
  config.app_password = 'YOUR_APP_PASSWORD_HERE'
  config.unity_url = 'CHOSEN_UNITY_URL'
end
```
## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/allscripts_api.
