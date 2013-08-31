Broadcastic gem
==========

## Installation & Configuration

Add broadcastic to your Gemfile, and then run `bundle install`

```ruby
gem 'broadcastic'
```

or install via gem

    gem install broadcastic

### Dependencies

Since broadcastic listens Rails' ActiveRecord callbacks, it is assumed to be run in a Rails app.

broadcastic depends on the pusher gem [pusher gem](https://github.com/pusher/pusher-gem) from [Pusher](http://pusher.com).

So, you need to get an account with Pusher and configure your app with their keys. Please read [their documentation on how to set this up](https://github.com/pusher/pusher-gem)

### Sync/Async
Broadcastic will detect if it is running inside of an EM loop and if so, use pusher's async style of invocation. If the server you are running is an evented server such as Thin, you are all set.

If you are running on a non-evented server, Broadcastic will revert to calling Pusher in a synchronous style.

### Global
The intent of broadcastic is to make it very easy to push ActiveRecord style callbacks to your pusher connected clients using minimal code in your ActiveRecord models.

### Broadcasting ActiveRecord changes
There are a few options when setting what you when you want to broadcast and who do you want to broadcast to.

The following example will broadcast an event to all users with a role of :admin after a new Product record is inserted into the
products table.

```ruby
class Product < ActiveRecord::Base
  broadcast :creations, to: admins

  def admins
    User.with_role :admin
  end

end
```