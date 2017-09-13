#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'json'
require 'httparty'
require 'optparse'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'so-docs.rb')
require File.join(dir, 'wayback-api.rb')
         
options = {
  :start => 0,
  :end => (2**(0.size * 8 -2) -1), # https://stackoverflow.com/questions/535721/ruby-max-integer
  :type => 'example'
}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} -s FIRST_EXAMPLE_ID -e LAST_EXAMPLE_ID"

  opts.on("-t", "--type example|topic", "") do |t|
    options[:type] = t
  end
  
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
posts = docs.load_json(options[:type]+'s')

posts.each do | post |
  id = post['Id']
  next if id < options[:start]
  exit if id > options[:end]
  
  url = "http://stackoverflow.com/documentation/contributors/#{options[:type]}/#{id}"

  wb = Wayback.new(url)
  wb.save_page
  puts "#{url} => #{wb.archive_url}"
  sleep 1 # Avoid IP-based throttling


end
                 
