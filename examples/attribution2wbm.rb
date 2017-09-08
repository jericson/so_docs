#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'json'
require 'httparty'
require 'optparse'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'so-docs.rb')
         
options = {
  :start => 0,
  :end => (2**(0.size * 8 -2) -1) # https://stackoverflow.com/questions/535721/ruby-max-integer
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} -s FIRST_EXAMPLE_ID -e LAST_EXAMPLE_ID"

  opts.on("-s", "--start FIRST_EXAMPLE_ID", "") do |s|
    options[:start] = s.to_i
  end

  opts.on("-e", "--end LAST_EXAMPLE_ID", "") do |e|
    options[:end] = e.to_i
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparse.parse!

docs = SODocs.new
examples = docs.load_json('examples')

examples.each do | example |
  id = example['Id']
  next if id < options[:start]
  exit if id > options[:end]
  
  url = 'http://stackoverflow.com/documentation/contributors/example/' +
        "#{id}"

  check_url = URI('https://web.archive.org/web/*/' + url)
  puts check_url
  response = HTTParty.get(check_url)
  puts response.code, response.message, response.headers.inspect

  # Based on https://github.com/pastpages/savepagenow/blob/master/savepagenow/api.py
  if response.headers["x-page-cache"] == "MISS"
  
    save_url = URI('https://web.archive.org/save/' + url)
    puts save_url
    response = HTTParty.get(save_url)
    puts response.code, response.message, response.headers.inspect
    exit unless response.code == 200
    sleep 1 # Be respectful of archive.org's resources
  end
end
                 
