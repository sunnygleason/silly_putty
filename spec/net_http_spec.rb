def client
  'SillyPutty::NetHttpClient'
end

require 'spec/spec_helper'
require 'silly_putty/clients/net_http'

describe SillyPutty::NetHttpClient do
  it_behaves_like "silly_putty"
end