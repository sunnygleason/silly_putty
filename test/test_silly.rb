require 'rubygems'
require 'silly_putty'
require 'silly_putty/clients/auto_detect'
require 'silly_putty/clients/kirk'
require 'silly_putty/clients/net_http'
require 'silly_putty/clients/patron'
require 'pp'

clients = [
  SillyPutty::NetHttpClient.new("localhost", 8080),
  SillyPutty::KirkClient.new("localhost", 8080),
  SillyPutty::PatronClient.new("localhost", 8080),
  SillyPutty::DefaultClient.new("localhost", 8080)
]

clients.each do |c|
  resp = c.do_request(:GET, "/bench", nil, nil)
  pp resp
end
