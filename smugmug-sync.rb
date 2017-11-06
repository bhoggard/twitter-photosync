#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv'
require 'oauth'
require 'ruby-smugmug'
require 'find'
Dotenv.load

def process_file(path)
  date = File.new(path).birthtime
  ymd = date.strftime('%Y-%m-%d')
  year = date.year
  puts "#{path}: #{year} #{ymd}"
end

count = 0
Find.find(ENV['PHOTOS_DIRECTORY']) do |path|
  next if FileTest.directory?(path) || path =~ /\.DS_Store$/
  process_file(path)
  count +=1
  break if count == 10
end

