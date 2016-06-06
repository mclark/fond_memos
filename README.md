# FondMemos

Another memoization gem, this time with simpler, easier to read code that hopefully everyone will feel safe using.
It just uses instance variables and hashes, no magic, nothing you wouldn't do in typical `@a ||= expensive_op`
memoization. It just extracts that logic out of methods where it shouldn't be in the first place.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fond_memos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fond_memos

## Usage

The class itself is well documented, more info can be found [here](lib/fond_memos.rb)

To memoize a method, simply require the gem, include the module in your class, and memoize the methods you want.
Single and multiple argument methods are handled the same.

```ruby
require 'fond_memos'

class Widget
  include FondMemos

  def expensive_calculation(a, b)
    # this takes seconds to run! so slow!
  end
  memoize(:expensive_calculation)
end

w = Widget.new
w.expensive_calculation(5, 4)    # slow!
w.expensive_calculation(99, 300) # slow!
w.expensive_calculation(5, 4)    # fast!
```

If you need to clear a memoized cache (perhaps something else changed an underlying variable
  which logically invalidated cache), simply call `forget`.

```ruby

w.forget(:expensive_calculation)
w.expensive_calculation(5, 4)    # slow again!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Alternatives

* [memoizable](https://github.com/dkubb/memoizable)
* [memoist](https://github.com/matthewrudy/memoist)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mclark/fond_memos. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
