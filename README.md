# Fixtory #

[![Build Status](https://secure.travis-ci.org/dockyard/fixtory.png?branch=master)](http://travis-ci.org/dockyard/fixtory)
[![Dependency Status](https://gemnasium.com/dockyard/fixtory.png?travis)](https://gemnasium.com/dockyard/fixtory)
[![Code Climate](https://codeclimate.com/github/dockyard/fixtory.png)](https://codeclimate.com/github/dockyard/fixtory)

Not quite fixtures, not quite factories.

## Looking for help? ##

If it is a bug [please open an issue on
GitHub](https://github.com/dockyard/fixtory/issues).

## About

Fixtory is an alternate syntax for working with fixture data. It also
allows for grouped data scenarios rather than the "all or nothing" that
ActiveRecord fixtures gives you. You'll be able to write your tests with
better data isolation.

## Installation ##

Add to your `Gemfile`

```ruby
gem 'fixtory'
```

In your `test_helper.rb` or `spec_helper.rb` add the following:

```ruby
require 'fixtory'
require 'fixtory/methods'
```

### Minitest

Mix the module:

```ruby
class Minitest::Spec
  include Fixtory::Methods
end
```

### Rspec

```ruby
# spec/support/fixtory.rb
RSpec.configure do |config|
  config.include Fixtory::Methods
end
```

## Usage

Start by adding a new Fixtory group file to `test/fixtories`. For
example you may add `test/fixtories/sign_up.rb`:

```ruby
users do
  brian do
    name 'Brian'
    email 'brian@dockyard.com'
    password 'password'
  end
end

profiles do
  one do
    role 'Developer'
    user users.brian
  end
end
```

In any test you can access this group of data with:

```ruby
data_group = fixtory(:sign_up)
```

You can further access the instances of the models:

```ruby
data_group.users.brian
=> <User name: 'Brian'>

data_group.profiles.one
=> <Profile role: 'Developer'>

data_group.profiles.one.user
=> <User name: 'Brian'>
```

Fixtory is smart enough to handle assigning all of your relationships.
Within the fixtory block you can access any other table at any other
time, even if it has not yet been defined. The following would have
worked just fine:

```ruby
profiles do
  one do
    role 'Developer'
    user users.brian
  end
end

users do
  brian do
    name     'Brian'
    email    'brian@dockyard.com'
    password 'password'
  end
end
```

Setting inverse relationships works:

```ruby
users do
  brian do
    name     'Brian'
    email    'brian@dockyard.com'
    password 'password'
    profile  profiles.one
  end
end

profiles do
  one do
    role 'Developer'
  end
end
```

And setting multiple relationships:

```ruby
owner do
  brian do
    name 'Brian'
    dogs [dogs.boomer, dogs.wiley]
  end
end

dogs do
  boomer do
    name 'Boomer'
  end

  wiley do
    name 'Wiley'
  end
end
```

## Fixtory Schema

The group files are broken down into two nested blocks. The outer blocks
represent tables and the inner blocks represent rows.

The name you use for the tables **must** match a valid table name in
your database.

The name you use for your rows **must** be unique for that table. It has
no reference to the data other than acting as a lable for which to
retrieve the data later.

The values you assign to in the row block **must** be valid database
columns. With the exception of relationships. You can assign a value to
the associated ActiveRecord model's association name and Fixtory will do
its best to transform this into the proper foreign key to set for
database insertion.

## Authors ##

* [Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/dockyard/fixtory/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Please do! We are always looking to improve this gem. Please see our
[Contribution Guidelines](https://github.com/dockyard/fixtory/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal ##

[DockYard](http://dockyard.com), Inc. &copy; 2014

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
