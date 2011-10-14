require 'kirk/client'

module SillyPutty
  class KirkClient < Base
    def do_request(method, uri, body, headers)
      response = Kirk::Client.request(method, @base_url + uri, nil, body, headers)
      
      Response.new(response.status, response.body, response.headers)
    end
  end
end