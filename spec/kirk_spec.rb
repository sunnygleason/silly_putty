def client
  'SillyPutty::KirkClient'
end

require 'spec/spec_helper'
require 'silly_putty/clients/kirk'

describe SillyPutty::KirkClient do
  it_behaves_like "silly_putty"
end