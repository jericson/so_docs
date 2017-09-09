require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    md5 = Digest::MD5.file('documentation-dump.7z')
    if md5 != 'c8013cdc92a1361af7b9d6e1aa2485fb'
      system("ruby examples/get-archive.rb")
      assert_equal $?, 0
    end
  end

  def test_archive
    assert_equal Digest::MD5.file('examples.json'),
                 'f4f3ece0a135afa08818181671c66766'
  end

  def test_example2html
    assert_equal Digest::MD5.hexdigest(`ruby examples/example2html.rb 404`),
                 '0fd26f8bdc0d0936909dbdedb4f27b7b'
  end
                 
end
