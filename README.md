# The GogoKit Ruby Gem

[![Build Status](https://travis-ci.org/viagogo/gogokit.rb.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/viagogo/gogokit.rb.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/viagogo/gogokit.rb/badges/gpa.svg)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/viagogo/gogokit.rb/badge.svg)][coverage]

[travis]: https://travis-ci.org/viagogo/gogokit.rb
[gemnasium]: https://gemnasium.com/viagogo/gogokit.rb
[codeclimate]: https://codeclimate.com/github/viagogo/gogokit.rb
[coverage]: https://coveralls.io/r/viagogo/gogokit.rb


Ruby toolkit for working with the viagogo API

## Troubleshooting on Windows

GogoKit uses SSL for all HTTP requests. On Windows you will need to configure where your certificates live since OpenSSL cannot find one to validate the authenticity. [This post](https://github.com/jnunemaker/httparty/wiki/Troubleshooting-on-Windows) describes how you can get this working on windows.