require 'net/http'

module SillyPutty
  class NetHttpClient < Base
    private

    def fixup_request(original)
      original.merge({:method => original[:method].to_s})
    end

    def perform_request(method, uri, body, headers)
      Net::HTTP.start(@host, @port) do |http|
        response = http.send_request(method, uri, body, headers)

        the_headers = {}
        response.each_capitalized {|k,v| the_headers[k] = v}

        Response.new(response.code.to_i, response.body, the_headers)
      end
    end
  end

  unless defined?(DefaultClient)
    class DefaultClient < SillyPutty::NetHttpClient
    end
  end
end