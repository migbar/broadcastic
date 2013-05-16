Broadcastic gem
==========

## Installation & Configuration

Add broadcastic to your Gemfile, and then run `bundle install`

    gem 'broadcastic'

or install via gem

    gem install broadcastic

## Dependencies

- Rails
Since broadcastic listens Rails' ActiveRecord callbacks, it is assumed to be run in a Rails app.

- Pusher
broadcastic depends on the pusher gem [pusher gem](https://github.com/pusher/pusher-gem) from [Pusher](http://pusher.com).

So you need to get an account with Pusher and configure your rails app with the security credentials. Please read [their documentation on how to set this up](https://github.com/pusher/pusher-gem)

- Thin
Broadcastic uses pusher's async style of invocation and therefore needs to be run in an evented server.

### Global
 - The intent of broadcastic is to make it very easy to push ActiveRecord callbacks to
 pusher connected client using minimal code in your ActiveRecord models.

### broadcasting ActiveRecord changes:

  broadcast :changes, to: :admins

