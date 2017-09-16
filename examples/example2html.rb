#!/usr/bin/env ruby -W1
# encoding: UTF-8

## Extracts and prints the HTML body of an example from the JSON archive.
## Example:
##    $ ./example2html.rb 30338 > OptionParser-intro.html


require 'httparty'
require 'json'
require 'date'
dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'so_docs.rb')
         
docs = SODocs.new

@topic_lookup = docs.index('topics', 'Id')
@example_lookup = docs.index('examples', 'Id')
@example_contributors = docs.multi_index('contributors', 'DocExampleId')
@tags = docs.index('doctags', 'Id')

abort('Usage: ' + $0 + ' example_id') unless ARGV.length >= 1

ARGV.each do | id |
  example = @example_lookup[id.to_i]
  tag = @tags[@topic_lookup[example['DocTopicId']]['DocTagId']]['Title']
  
  puts <<"HEADER"
<!DOCTYPE html>
<head>
  <title>#{example['Title']}&mdash;#{tag}</title>
</head>
<body>
<h2>#{tag}</h2>
<h1>#{example['Title']}</h1>
HEADER
                 
  puts example['BodyHtml']

  puts <<"ATTRIBUTION"
<hr />
<p>Created by:<ul>
ATTRIBUTION
  user_ids = @example_contributors[id.to_i].map { |u| u['UserId'] }.uniq
  display_names = docs.fetch_display_names(user_ids)
  user_ids.each do | contributor |
    puts <<"CONTRIBUTORS"
    <li><a href='https://stackoverflow.com/users/#{contributor}'>
        #{display_names[contributor]}</a></li>
CONTRIBUTORS
  end
  puts <<"FOOTER"
</ul></p>
<p>This content was ported over from Stack Overflow Documentation, now retired. To access the source and attribution please access the <a href="https://archive.org/details/documentation-dump.7z">Docs archive</a> and reference topic ID: #{example['DocTopicId']} and example ID: #{id}.</p>
<p>All user contributions licensed under <a href='https://creativecommons.org/licenses/by-sa/3.0/'>CC BY-SA 3.0</a> with <a href="https://stackoverflow.blog/2009/06/25/attribution-required/">attribution required</a>.</p>
</body>
</html>
FOOTER
end
