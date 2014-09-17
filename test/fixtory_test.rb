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
end
