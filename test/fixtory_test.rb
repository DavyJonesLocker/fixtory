require 'test_helper'

describe 'Fixtories' do
  it 'builds a table hash for insertion' do
    path = File.expand_path('test/fixtories/test_1.rb')
    hash = Fixtory::DSL.build_from(path).to_hash

    expected = {
      'owners' => {
        'brian' => {
          'id' => ActiveRecord::FixtureSet.identify('brian'),
          'name' => 'Brian',
          'age' => 35
        }
      },
      'dogs' => {
        'boomer' => {
          'id' => ActiveRecord::FixtureSet.identify('boomer'),
          'name' => 'Boomer',
          'age' => 1.5
        },
        'wiley'  => {
          'id' => ActiveRecord::FixtureSet.identify('wiley'),
          'name' => 'Wiley',
          'age' => 12
        }
      }
    }

    assert_equal hash, expected
  end

  it 'allows access to specific rows from builder' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)
    builder.insert

    assert_equal builder.owners.brian.age, 35
  end

  it 'instantiates model when retrieved' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)
    builder.insert

    assert_instance_of Owner, builder.owners.brian
  end

  it 'provides a "fixtory" method to access a group' do
    test_group = fixtory(:test_1)
    assert_instance_of Fixtory::DSL::Builder, test_group
  end

  it 'inserts into the database' do
    count = Owner.count

    fixtory(:test_1)

    refute_equal Owner.count, count
  end
end
