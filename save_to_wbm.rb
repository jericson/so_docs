require 'json'
require 'httparty'

tags = JSON.parse(IO.read('doctags.json'))

def slugify (s)
   # https://stackoverflow.com/questions/4308377/ruby-post-title-to-slug/4308399#4308399
  return s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '').squeeze('-')
end

tag_lookup = {}
tags.each do | tag |
  tag_lookup[tag['Id']] = tag['Tag']
end

topics = JSON.parse(IO.read('topics.json'))

topics.each do | topic |
  url = 'https://web.archive.org/save/https://stackoverflow.com/documentation/' +
        tag_lookup[topic['DocTagId']] +
        "/#{topic['Id']}/" +
        slugify(topic['Title'])

  response = HTTParty.get(url)

  puts response.code, response.message, response.headers.inspect
end
                 
