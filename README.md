# The GogoKit Ruby Gem

[![Gem Version](https://badge.fury.io/rb/gogokit.svg)][gem]
[![Downloads](https://img.shields.io/gem/dt/gogokit.svg)][gem]
[![Build Status](https://travis-ci.org/viagogo/gogokit.rb.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/viagogo/gogokit.rb.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/viagogo/gogokit.rb/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/viagogo/gogokit.rb/badge.svg)][coverage]

[gem]: https://rubygems.org/gems/gogokit
[travis]: https://travis-ci.org/viagogo/gogokit.rb
[gemnasium]: https://gemnasium.com/viagogo/gogokit.rb
[codeclimate]: https://codeclimate.com/github/viagogo/gogokit.rb
[coverage]: https://coveralls.io/r/viagogo/gogokit.rb
[apidocs]: http://developer.viagogo.net
[semver]: http://semver.org/
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[troubleshootwindows]: https://github.com/jnunemaker/httparty/wiki/Troubleshooting-on-Windows
[submitanissue]: https://github.com/viagogo/gogokit.rb/issues
[apidocsgettingstarted]: http://developer.viagogo.net/#getting-started


Ruby toolkit for working with the viagogo API. Our [developer site][apidocs]
documents all of the viagogo APIs.


## Installation

Install via Ruby gems

    gem install gogokit

... or add to your Gemfile

    gem 'gogokit', '~> 0.4'


## Usage

See our [developer site][apidocsgettingstarted] for more examples.

```ruby
require 'gogokit'

# All methods require OAuth2 authentication. To get OAuth2 credentials for your
# application, see http://developer.viagogo.net/#authentication.
client = GogoKit::Client.new do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET
end

# Get an access token. See http://developer.viagogo.net/#getting-access-tokens
token = client.get_client_access_token
client.access_token = token.access_token

# Get a list of events, categories, venues and metro areas that match the given
# search query
search_results = client.search 'FC Barcelona tickets'

# Get the different event genres (see http://developer.viagogo.net/#entities)
genres = client.get_genres
```

### Request Headers, Query Parameters and Body

The last parameter of all GogoKit::Client methods is an `options` Hash that
supports `headers`, `params` and `body` keys for specifying request headers,
query parameters and body respectively.

```ruby
events = client.get_events_by_category(CATEGORY_ID,
                                       headers: {'Accept-Language' => 'JA'},
                                       params: {'sort' => 'name'})
```

### Configuration and defaults

GogoKit::Client accepts a range of options when creating a new client instance.

#### Configuring client instances

Every writeable attribute in {GogoKit::Configuration} can be set one at a time

```ruby
client = GogoKit::Client.new
client.client_id = YOUR_CLIENT_ID
client.api_root_endpoint = 'https://sandbox.api.viagogo.net'
```

or in a block:

```ruby
client = GogoKit::Client.new do |config|
  config.client_id = YOUR_CLIENT_ID
  config.api_root_endpoint = 'https://sandbox.api.viagogo.net'
end
```

#### Using ENV variables

Default configuration values are specified in {GogoKit::Default}. Many
attributes will look for a default value from the ENV before returning GogoKit's
default.

```ruby
# Given $GOGOKIT_CLIENT_ID is "abcd1234" and $GOGOKIT_API_ROOT_ENDPOINT is
# "http://sandbox.api.viagogo.net"
client = GogoKit::Client.new
client.client_id
client.api_root_endpoint

# => "abcd1234"
# => "http://sandbox.api.viagogo.net"
```

## How to contribute

All submissions are welcome. Fork the repository, read the rest of this README
file and make some changes. Once you're done with your changes send a pull
request. Thanks!


## Need Help? Found a bug?

Just [submit a issue][submitanissue] if you need any help. And, of course, feel
free to submit pull requests with bug fixes or changes.


## Supported Ruby Versions

This library aims to support and is [tested against][travis] the following Ruby
implementations:

* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.0
* Ruby 2.2.0

If something doesn't work on one of these Ruby versions, it's a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, but support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be responsible for providing patches in a timely
fashion. If critical issues for a particular implementation exist at the time
of a major release, support for that Ruby version may be dropped.


### Troubleshooting on Windows

GogoKit uses SSL for all HTTP requests. On Windows you will need to configure
where your certificates live since OpenSSL cannot find one to validate
the authenticity. [This post][troubleshootwindows] describes how you can get
this working on windows.


## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, that version should be
immediately yanked and/or a new version should be immediately released that
restores compatibility. Breaking changes to the public API will only be
introduced with new major versions. As a result of this policy, you can (and
should) specify a dependency on this gem using the [Pessimistic Version
Constraint][pvc] with two digits of precision. For example:

    spec.add_dependency 'gogokit', '~> 0.4'
