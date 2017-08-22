#!/usr/bin/env ruby -W1
# encoding: UTF-8

require 'json'
require 'httparty'

def slugify (s)
   # https://stackoverflow.com/questions/4308377/ruby-post-title-to-slug/4308399#4308399
  return s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').squeeze('-')
end

tags = JSON.parse(IO.read('doctags.json'))

tag_lookup = {}
tags.each do | tag |
  tag_lookup[tag['Id']] = tag['Tag']
end

topics = JSON.parse(IO.read('topics.json'))

topics.each do | topic |
  url = URI('https://web.archive.org/save/https://stackoverflow.com/documentation/' +
            tag_lookup[topic['DocTagId']] +
            "/#{topic['Id']}/" +
            slugify(topic['Title']))

  response = HTTParty.get(url)

  puts response.code, response.message, response.headers.inspect
end
                 
