
module SillyPutty
  class Base
    attr_reader :host, :port, :base_url
    attr_accessor :request_handler, :response_handler

    def initialize(host, port)
      @host = host
      @port = port
      @base_url = "http://" + host + ":" + port.to_s
    end

    def request(method, uri, body, headers)
      @request_handler.call({:method => method, :base_url => @base_url, :path => uri, :body => body, :headers => headers}) if @request_handler

      response = perform_request(method, uri, body, headers)
      
      @response_handler.call({:status => response.status, :body => response.body, :headers => response.headers}) if @response_handler

      response
    end
    
    private
    
    def perform_request(method, uri, body, headers)
      raise 'not implemented!'
    end
  end

  class Response
    attr_reader :status, :body, :headers
    
    def initialize(status, body, headers)
      @status  = status
      @body    = body
      @headers = headers
    end
  end
end
