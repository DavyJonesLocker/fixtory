require 'test_helper'

describe 'Fixtories' do
  it 'allows access to specific rows from builder' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)
    builder._insert

    assert_equal builder.owners.brian.age, 35
  end

  it 'instantiates model when retrieved' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)
    builder._insert

    assert_instance_of Owner, builder.owners.brian
  end

  it 'allows relationships to be set' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)
    builder._insert

    assert_equal builder.owners.brian, builder.dogs.boomer.owner
  end

  it 'allows relationships to be set from parent' do
    path = File.expand_path('test/fixtories/test_2.rb')
    builder = Fixtory::DSL.build_from(path)
    builder._insert

    assert_equal [builder.dogs.boomer], builder.owners.brian.dogs
  end

  it 'allows has one relationship' do
    path = File.expand_path('test/fixtories/test_3.rb')
    builder = Fixtory::DSL.build_from(path)
    builder._insert

    assert_equal builder.books.moby_dick, builder.owners.brian.book
  end

  it 'provides a "fixtory" method to access a group' do
    test_group = fixtory(:test_1)
    assert Fixtory::DSL::Builder === test_group
  end

  it '_inserts into the database' do
    count = Owner.count

    fixtory(:test_1)

    refute_equal Owner.count, count
  end
end
