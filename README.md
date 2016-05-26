# Weasel

Like [Jimmy Fratianno](https://en.wikipedia.org/wiki/Jimmy_Fratianno), this gem got the nickname "Weasel", from a witness who saw him outrun police. Telling all about **who** is doing **what** from **where** and **when**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weasel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weasel

## Usage

First, you'll need to create a table like this:

```ruby
class AddWeaselTables < ActiveRecord::Migration
  def self.up
    create_table :weasel_events do |t|
      t.integer :actor_id
      t.string  :actor_type
      t.text    :action_data

      t.timestamps
    end

    def self.down
      drop_table :weasel_events
    end
  end
end
```

Then, create an initializer to configure Weasel. Put this in it:

```ruby
Weasel.configure do |config|
  config.db_configuration = ActiveRecord::Base.connection_config
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goodpeople/weasel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
