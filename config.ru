$:.unshift(File.expand_path('../lib', __FILE__))
require 'ip_geo/server'
run IPGeo::Server.new
