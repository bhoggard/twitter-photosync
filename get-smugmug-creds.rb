#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv'
require 'oauth'
Dotenv.load

raise 'Missing SmugMug config' unless
  ENV['SMUGMUG_CONSUMER_KEY'] && ENV['SMUGMUG_CONSUMER_SECRET']

callback_url = 'oob'

consumer = OAuth::Consumer.new(
  ENV['SMUGMUG_CONSUMER_KEY'], ENV['SMUGMUG_CONSUMER_SECRET'],
  site: 'https://secure.smugmug.com',
  request_token_path: '/services/oauth/1.0a/getRequestToken',
  authorize_path: '/services/oauth/1.0a/authorize?Access=Full&Permissions=Add',
  access_token_path: '/services/oauth/1.0a/getAccessToken'
)
request_token = consumer.get_request_token(oauth_callback: callback_url)

puts "Visit the following URL, log in if you need to, and authorize the app"
puts request_token.authorize_url(oauth_callback: callback_url)

puts "When you've authorized that token, enter the verifier code you are assigned:"
verifier = gets.strip                                                                                                                                                               
puts "Converting request token into access token..."                                                                                                                                
access_token = request_token.get_access_token(oauth_verifier: verifier)
puts "TOKEN: #{access_token.token}"
puts "SECRET: #{access_token.secret}"
