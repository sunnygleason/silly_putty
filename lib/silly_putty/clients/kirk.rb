require 'kirk/client'

module SillyPutty
  class KirkClient < Base
    private
    def fixup_request(original)
      headers = original[:headers]
      headers = headers.merge({"Accept" => "*/*"})
      
      if original[:body] && headers["Content-Type"].nil?
        headers = headers.merge({"Content-Type" => "application/x-www-form-urlencoded"})
      end

      original.merge({:headers => headers})
    end

    def perform_request(method, uri, body, headers)
      response = Kirk::Client.request(method, @base_url + uri, nil, body, headers)
      
      Response.new(response.status, response.body, response.headers)
    end
  end

  unless defined?(DefaultClient)
    class DefaultClient < SillyPutty::KirkClient
    end
  end
end