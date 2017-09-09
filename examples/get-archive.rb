#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'httparty'
require 'seven_zip_ruby'

response = nil
filename = 'documentation-dump.7z'
url = "https://archive.org/download/documentation-dump.7z/#{filename}"
path = ARGV[1] ||= '.'


File.open(filename, "w") do |file|
  response = HTTParty.get(url, stream_body: true) do |fragment|
    print "."
    file.write(fragment)
  end
end

File.open(filename, "rb") do |file|
  SevenZipRuby::Reader.extract_all(file, path)
end
