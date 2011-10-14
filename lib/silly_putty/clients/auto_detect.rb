
module SillyPutty
  if defined?(JRUBY_VERSION)
    require 'silly_putty/clients/net_http'
    class DefaultClient < SillyPutty::NetHttpClient
    end
  else
    require 'silly_putty/clients/patron'
    class DefaultClient < SillyPutty::PatronClient
    end
  end
end