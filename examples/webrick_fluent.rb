#!/usr/bin/env ruby

require 'pathname'
require 'webrick'
$LOAD_PATH.unshift Pathname.new(__FILE__).parent.parent.join('lib')
require 'fluent_interface'

# server = fluent.DocumentRoot('/var/www').BindAddress('0.0.0.0').Port(8001).execute

#fluent = FluentInterface.fluent WEBrick::HTTPServer, :new, WEBrick::Config::HTTP.keys
#server = fluent.DocumentRoot('/var/www').BindAdress('0.0.0.0').Port(8001).execute

fluent = FluentInterface.fluent WEBrick::HTTPServer, :new, WEBrick::Config::HTTP.keys
fluent = fluent.DocumentRoot('/var/www').Port(8001)
fluent = fluent.BindAddress('0.0.0.0')
server = fluent.execute
Signal.trap('INT'){ server.shutdown }
server.start


