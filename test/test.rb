require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    if !File.exist?('documentation-dump.7z')      
      system("ruby examples/get-archive.rb")
      assert_equal $?, 0
    end
    assert Digest::MD5.file('documentation-dump.7z'),
           'c8013cdc92a1361af7b9d6e1aa2485fb'    
  end

  def test_archive
    assert_equal Digest::MD5.file('examples.json'),
                 'f4f3ece0a135afa08818181671c66766'
  end

  def test_example2html
    assert_equal Digest::MD5.hexdigest(`ruby examples/example2html.rb 404`),
                 '8cd9819ca8747f518b691f5a0e1886d5'
  end
                 
end
