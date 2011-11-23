def client
  'SillyPutty::PatronClient'
end

require 'spec/spec_helper'
require 'silly_putty/clients/patron'

describe SillyPutty::PatronClient do
  it_behaves_like "silly_putty"
end