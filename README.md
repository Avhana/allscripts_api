# AllscriptsApi, an Allscripts Unity Client

[![Coverage Status](https://coveralls.io/repos/github/Avhana/allscripts_api/badge.svg?branch=master)](https://coveralls.io/github/Avhana/allscripts_api?branch=master)
[![Build Status](https://travis-ci.org/Avhana/allscripts_api.svg?branch=master)](https://travis-ci.org/Avhana/allscripts_api)
[![Inline docs](http://inch-ci.org/github/Avhana/allscripts_api.svg?branch=master&style=shields)](http://inch-ci.org/github/Avhana/allscripts_api)
[![Dependency Status](https://gemnasium.com/badges/github.com/Avhana/allscripts_api.svg)](https://gemnasium.com/github.com/Avhana/allscripts_api)
[![Maintainability](https://api.codeclimate.com/v1/badges/9889f5255914a5fcbeb5/maintainability)](https://codeclimate.com/github/Avhana/allscripts_api/maintainability)
[![security](https://hakiri.io/github/Avhana/allscripts_api/master.svg)](https://hakiri.io/github/Avhana/allscripts_api/master)

AllscriptsApi is a simple ruby wrapper around the [Allscripts Unity API](https://developer.allscripts.com/APIReference/). This gem specifically focuses on the JSON 
functionality of the API and will not support SOAP. Additionally, `allscripts_api` focuses on being simple 
to use and understand. There are no DSLs, or behind the scenes magic. The code aims to be well documented, 
readable, and straightforward to use in your own application. The docs are available [here](http://www.rubydoc.info/github/Avhana/allscripts_api/master/AllscriptsApi)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'allscripts_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allscripts_api

## Usage
The client can be used either with ahead of time configuration and instantiated with `AllscriptsApi.connect`, or by directly calling
`AllscriptsApi::Client.new`, and passing your applications credentials.
### Optional Configuration

You may configure the client beforehand with the following config block. If you are using Rails,
this will go in `cofig/initializers`. However, the code does not rely on ActiveSupport and can
be configured ahead of time in and Ruby application.

```ruby
AllscriptsApi.configure do |config|
  config.app_name = 'YOUR_APP_NAME_HERE'
  config.app_username = 'YOUR_APP_USERNAME_HERE'
  config.app_password = 'YOUR_APP_PASSWORD_HERE'
  config.unity_url = 'CHOSEN_UNITY_URL'
end
```

If you have configured you application ahead of time, you can test your set up now.
```ruby
client = AllscriptsApi.connect
client.get_token
```

If this works, the client should set a token, and you should see it printed to the console. If it fails for any reason, it will raise [`GetTokenError`](https://github.com/Avhana/allscripts_api/blob/master/lib/allscripts_api.rb#L16), and dump the response body of the GetToken call to Unity.

Assuming a successful call to GetToken, next authenticate the test user to that token.

```ruby
client.get_user_authentication("jmedici", "password01")
```

This call will return a [`MagicError`](https://github.com/Avhana/allscripts_api/blob/master/lib/allscripts_api.rb#L12) if it fails.

### Directly Building the Client
If you want to use the gem from the console, or without ahead of time configuration, you may do so as follows.
```ruby
  client =
    AllscriptsApi::Client.new(unity_url, app_name, app_username, app_password)
  client.get_token
  client.get_user_authentication("jmedici", "password01")
```
As you can see, after the initial call, usage is the same. That is because `AllscriptsApi.connect` returns an instance of `AllscriptsApi::Client`. You can find the documentation for `AllscriptsApi.connect` [here](http://www.rubydoc.info/github/Avhana/allscripts_api/master/AllscriptsApi/Client).


## Code of Conduct
In order to have a more open and welcoming community of contributors and users, Avhana Health will enforce a [Code of Conduct](https://github.com/avhana/allscripts_api/blob/master/code-of-conduct.md), which follows v1.4 of the [Contributors Covenant](https://www.contributor-covenant.org/version/1/4/code-of-conduct.html).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/avhana/allscripts_api.

## License

This gem is provided as is under the [MIT license](https://github.com/avhana/allscripts_api/blob/master/LICENSE), Copyright (c) 2018 Avhana Health, Inc.
