#!/usr/bin/env ruby -W1
# encoding: UTF-8

## Extracts and prints the HTML body of an example from the JSON archive.
## Example:
##    $ ./example2html.rb 30338 > OptionParser-intro.html


require 'httparty'
require 'json'
require 'htmlentities'
require 'date'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'so-docs.rb')
         
docs = SODocs.new

@example_lookup = docs.index_examples('Id')
@example_contributors = docs.index_contributors('DocExampleId')

abort('Usage: ' + $0 + ' example_id') unless ARGV.length >= 1

ARGV.each do | id |
  puts <<"HEADER"
<!DOCTYPE html>
<head>
  <title>#{@example_lookup[id.to_i]['Title']}</title>
</head>
<body>
HEADER
                 
  puts @example_lookup[id.to_i]['BodyHtml']

  puts '<p>Created by: <ul>'
  @example_contributors[id.to_i].each do | contributor |
    puts "<li>https://stackoverflow.com/users/#{contributor['UserId']}</li>"
  end
  puts <<"FOOTER"
</ul></p>
</body>
</html>
FOOTER
end
