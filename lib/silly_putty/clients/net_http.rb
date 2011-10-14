require 'net/http'

module SillyPutty
  class NetHttpClient < Base
    private
    def perform_request(method, uri, body, headers)
      Net::HTTP.start(@host, @port) do |http|
        response = http.send_request(method, uri, body, headers)

        Response.new(response.code.to_i, response.body, Hash[response.each_capitalized.to_a])
      end
    end
  end

  class DefaultClient < SillyPutty::NetHttpClient
  end
end