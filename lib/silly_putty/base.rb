
module SillyPutty
  class Base
    attr_accessor :host, :port, :base_url, :request_handler, :response_handler

    def initialize(host, port)
      @host = host
      @port = port
      @base_url = "http://" + host + ":" + port.to_s
      @request_handler  = nil
      @response_handler = nil
    end

    def request_impl(method, uri, body, headers)
      raise 'not implemented!'
    end

    def do_request(method, uri, body, headers)
      @request_handler.call({:method => method, :base_url => @base_url, :path => uri, :body => body, :headers => headers}) if @request_handler

      response = request_impl(method, uri, body, headers)
      
      @response_handler.call({:status => response.status, :body => response.body, :headers => response.headers}) if @response_handler

      response
    end
  end

  class Response
    attr_accessor :status, :body, :headers
    
    def initialize(status, body, headers)
      @status  = status
      @body    = body
      @headers = headers
    end
  end
end
