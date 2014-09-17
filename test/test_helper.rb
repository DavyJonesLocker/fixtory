require 'minitest/autorun'
require 'fixtory'
require 'fixtory/methods'
require 'byebug'
require 'active_record'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class Minitest::Spec
  include Fixtory::Methods

  before do
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

ActiveRecord::Base.connection.execute(%{CREATE TABLE owners (id INTEGER PRIMARY KEY, name TEXT, age DOUBLE);})
ActiveRecord::Base.connection.execute(%{CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, age DOUBLE, owner_id INTEGER);})

class Owner < ActiveRecord::Base

end

class Dog < ActiveRecord::Base

end
