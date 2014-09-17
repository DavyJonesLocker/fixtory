require 'test_helper'

describe 'Fixtories' do
  it 'builds a table hash for insertion' do
    path = File.expand_path('test/fixtories/test_1.rb')
    hash = Fixtory::DSL.build_from(path).to_hash

    expected = {
      'owners' => {
        'brian' => { 'name' => 'Brian', 'age' => 35 }
      },
      'dogs' => {
        'boomer' => { 'name' => 'Boomer', 'age' => 1.5 },
        'wiley'  => { 'name' => 'Wiley', 'age' => 12 }
      }
    }

    assert_equal hash, expected
  end

  it 'allows access to specific rows from builder' do
    path = File.expand_path('test/fixtories/test_1.rb')
    builder = Fixtory::DSL.build_from(path)

    assert_equal builder.owners.brian.age, 35
  end
end
