#!/usr/bin/env ruby

# frozen_string_literal: true

require 'drb/drb'
require 'dotenv'

require './api_definitions'

Signal.trap('INT') do
  puts "\nStopping..."
  exit 1
end

Dotenv.load('.env.local', '.env')

object = ApiDefinitions.new
port = ENV.fetch('MODERN_RUBY_API_WRAPPER_HOST_PORT')
DRb.start_service("druby://#{port}", object)

puts 'Started...'
DRb.thread.join
