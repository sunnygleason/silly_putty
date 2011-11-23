require 'patron'

module SillyPutty
  class PatronClient < Base
    private

    def fixup_request(original)
      headers = original[:headers]

      if !original[:body].nil? && headers["Content-Type"].nil?
        headers = headers.merge({"Content-Type" => "application/x-www-form-urlencoded"})
      end

      original.merge({:headers => headers})
    end

    def perform_request(method, uri, body, headers)
      options = {}
      options[:data] = body unless body.nil?
      headers = headers ? headers : {}

      response = Patron::Session.new.request(method.to_s.downcase.to_sym, @base_url + uri, headers, options)

      Response.new(response.status, response.body, response.headers)
    end
  end

  unless defined?(DefaultClient)
    class DefaultClient < SillyPutty::PatronClient
    end
  end
end