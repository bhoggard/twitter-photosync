#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv'
require 'ruby-smugmug'
require 'find'
Dotenv.load

$client = SmugMug::Client.new(
  api_key: ENV['SMUGMUG_CONSUMER_KEY'],
  oauth_secret: ENV['SMUGMUG_CONSUMER_SECRET'],
  user: { token: ENV['SMUGMUG_ACCESS_TOKEN'], secret: ENV['SMUGMUG_ACCESS_SECRET']})

$archive_category = client.categories.get.find { |c| c['Name'] == ENV['ARCHIVE_CATEGORY'] }

# find the subcategory for a given year, or create it
def find_subcategory(year)
  subcategory = $client.subcategories.get(CategoryID: $archive_category['id']).find { |sc| sc['Name'] == year }
  return subcategory if subcategory
  subcategory = client.subcategories.create(CategoryID: 2538725754, Name: year)
end

def process_file(path)
  date = File.new(path).birthtime
  ymd = date.strftime('%Y-%m-%d')
  year = date.year
  puts "#{path}: #{year} #{ymd}"
  subcategory = find_subcategory(year)
  subcat_id = subcategory['id']
end

count = 0
Find.find(ENV['PHOTOS_DIRECTORY']) do |path|
  next if FileTest.directory?(path) || path =~ /\.DS_Store$/
  process_file(path)
  count +=1
  break if count == 10
end

