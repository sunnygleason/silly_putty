
require 'silly_putty'
require 'rubygems'
require 'webrick'
require 'json'

# yes, this seemed clean at the time
class String
  def to_class
    chain = self.split "::"
    i=0
    res = chain.inject(Module) do |ans,obj|
      break if ans.nil?
      i+=1
      klass = ans.const_get(obj)
      # Make sure the current obj is a valid class 
      # Or it's a module but not the last element, 
      # as the last element should be a class
      klass.is_a?(Class) || (klass.is_a?(Module) and i != chain.length) ? klass : nil
    end
  rescue NameError
    nil
  end
end

class EchoServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_HEAD(request, response)
    handle(:HEAD, request, response)
  end

  def do_GET(request, response)
    handle(:GET, request, response)
  end

  def do_POST(request, response)
    handle(:POST, request, response)
  end

  def do_PUT(request, response)
    handle(:PUT, request, response)
  end

  def do_DELETE(request, response)
    handle(:DELETE, request, response)
  end
  
  def handle(method, request, response)
    if request['expect'] == "100-continue" && request.http_version.to_s >= "1.1"
      request.instance_variable_get(:@socket).write "HTTP/#{response.http_version} 100 continue\r\n\r\n"
    end
    
    headers = {}
    request.raw_header.each do |h|
      h.chomp!
      p = h.index(': ')
      headers[h[0..p-1]] = h[p+2..-1]
    end
    
    response.status = request['x-desired-status'] || 200
    response['Content-Type'] = request['x-desired-content-type'] || "application/json"
    response.body = request['x-desired-body'] || JSON({
      :method => method,
      :headers => headers,
      :uri => request.unparsed_uri,
      :body => request.body
    })
  end
end

shared_examples "silly_putty" do
  before(:each) do
    @port = 5000 + rand(1000)
    @client = client.to_class.new("localhost", @port)
    @server = WEBrick::HTTPServer.new(:Port=>@port, :ServerName=>"localhost", :Logger => WEBrick::Log.new("/dev/null"), :AccessLog => [nil, nil])
    @server.mount("/", EchoServlet)
    Thread.new(@server) {|server| server.start} 
  end
  
  after(:each) do
    @server.stop
  end
  
  it "should be instantiable" do
    @client.nil?.should == false
  end

  it "methods work with nil body" do
    [:GET, :DELETE].each do |m|
      JSON(@client.request(m, "/foo", nil, {'Foo' => 'bar'}).body).should == {
        "method"=> m.to_s,
        "headers"=>{"Foo"=>"bar", "Host"=>"localhost:" + @port.to_s, "Accept"=>"*/*"},
        "uri"=>"/foo", "body"=>nil}
    end
  end
  
  it "methods work with zero-length body" do
    [:POST].each do |m|
      JSON(@client.request(m, "/foo", "", {'Foo' => 'bar'}).body).should == {
        "method"=> m.to_s,
        "headers"=>{"Foo"=>"bar", "Host"=>"localhost:" + @port.to_s, "Accept"=>"*/*", "Content-Length"=>"0", "Content-Type"=>"application/x-www-form-urlencoded"},
        "uri"=>"/foo", "body"=>nil}
    end
    [:PUT].each do |m|
      JSON(@client.request(m, "/foo", "", {'Foo' => 'bar'}).body).should == {
        "method"=> m.to_s,
        "headers"=>{"Foo"=>"bar", "Host"=>"localhost:" + @port.to_s, "Accept"=>"*/*", "Content-Length"=>"0", "Content-Type"=>"application/x-www-form-urlencoded"},
        "uri"=>"/foo", "body"=>nil}
    end
  end

  it "works with non-empty body" do
    [:POST, :PUT].each do |m|
      JSON(@client.request(m, "/foo", 'whee', {'Foo' => 'bar'}).body).should == {
        "method"=> m.to_s,
        "headers"=>{"Host"=>"localhost:" + @port.to_s, "Accept"=>"*/*","Foo"=>"bar",  "Content-Length"=>"4", "Content-Type"=>"application/x-www-form-urlencoded"},
        "uri"=>"/foo", "body"=>'whee'}
    end
  end
end
