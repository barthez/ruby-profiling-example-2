#!/usr/bin/env ruby

require 'open-uri'
require 'active_support/core_ext/string/inflections'

File.open('cities.txt').each do |line|
  print "Downloading #{line.strip}..."
  url = "http://demo.twofishes.net/?query=#{URI.encode(line.strip)}"
  json = open(url).read
  File.write("cities/#{line.parameterize}.json", json)
  puts "done."
end
