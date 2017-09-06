#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'json'
require 'httparty'

examples = JSON.parse(IO.read('examples.json'))

examples.each do | example |
  # Use HTTP rather than HTTPS because it can be slower
  url = URI('https://web.archive.org/save/http://stackoverflow.com/documentation/contributors/example/' +
        "#{example['Id']}")

  puts url
  response = HTTParty.get(url)
  puts response.code, response.message, response.headers.inspect
end
                 
