require 'minitest/autorun'
require 'digest/md5'

class TestDocsDump < Minitest::Test
  def setup
    system("ruby examples/get-archive.rb")
    assert_equal $?, 0
  end

  def test_archive
    assert_equal Digest::MD5.file('examples/examples.json'),
                 'f4f3ece0a135afa08818181671c66766'
  end

  def test_example2html
    assert_equal Digest::MD5.hexdigest(`ruby examples/example2html.rb 404`),
                 '0fd26f8bdc0d0936909dbdedb4f27b7b'
  end
                 
end
