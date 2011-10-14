
module SillyPutty
  class Base
    attr_accessor :host, :port, :base_url

    def initialize(host, port)
      @host = host
      @port = port
      @base_url = "http://" + host + ":" + port.to_s
    end

    def do_request(method, uri, body, headers)
      raise 'not implemented!'
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
