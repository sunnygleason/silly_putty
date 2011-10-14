require 'net/http'

module SillyPutty
  class NetHttpClient < Base
    def do_request(method, uri, body, headers)
      Net::HTTP.start(@host, @port) do |http|
        response = http.send_request(method, uri, body, headers)

        # TODO: is there a more idiomatic way?
        resp_headers = {}
        response.each_capitalized do |k,v|
          resp_headers[k] = v
        end
        
        Response.new(response.code.to_i, response.body, resp_headers)
      end
    end
  end
end