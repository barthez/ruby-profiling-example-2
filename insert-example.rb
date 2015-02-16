#!/usr/bin/env ruby

require "ruby-prof"
require "ruby-prof-flamegraph"
require "moped"
require "bson"
require "json"

session = Moped::Session.new([ "127.0.0.1:27017" ])
session.use "prof_test"
session.drop

result = RubyProf.profile do

  Dir['cities/*.json'].each do |file|
    geocode = JSON.load(File.open(file))
    interp = geocode['interpretations'].first

    if interp
      feature = interp['feature']
      name = feature['displayName']
      country_code = feature['cc']
      point = feature['geometry']['center']

      session[:capitals].insert(:name => name, :country_code => country_code, :coordinates => [point['lat'], point['lng'] ])
    end
  end

end

File.open('prof.flame.txt', 'wb') do |f|
  printer = RubyProf::FlameGraphPrinter.new(result)
  printer.print(f)
end
