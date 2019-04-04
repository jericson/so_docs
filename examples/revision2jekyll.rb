#!/usr/bin/env ruby -W1
# encoding: UTF-8

## Extracts and prints the Markdown body of a topic revision from the
## JSON archive.
## Example:
##    $ ./examples/revision2jekyll.rb 200328 > JavaArraysFinal.md


require 'httparty'
require 'json'
require 'htmlentities'
require 'date'

@topic_histories = JSON.parse(IO.read('topichistories.json'))

@topic_history_lookup = {}
@topic_histories.each do | topic_history |
  @topic_history_lookup[topic_history['Id'].to_i] = topic_history
end

abort('Usage: ' + $0 + ' revision_id') unless ARGV.length >= 1

ARGV.each do | id |
  puts @topic_history_lookup[id.to_i]['Text']
end
