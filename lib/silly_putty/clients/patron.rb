require 'patron'

module SillyPutty
  class PatronClient < Base
    private
    def perform_request(method, uri, body, headers)
      options = {}
      options[:data] = body unless body.nil?
      headers = headers ? headers : {}

      response = Patron::Session.new.request(method.to_s.downcase.to_sym, @base_url + uri, headers, options)

      Response.new(response.status, response.body, response.headers)
    end
  end

  class DefaultClient < SillyPutty::PatronClient
  end
end