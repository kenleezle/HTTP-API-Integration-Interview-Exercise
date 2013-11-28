require 'socket'

class TestHttpServer
  @@threads = Array.new

  def initialize(port=11001,response_code=500,response_body="")
    @response_code = response_code
    @response_body = response_body
    @server = TCPServer.new('localhost', port)
  end
  def run
    loop do
      socket = @server.accept
      request = socket.gets

      socket.print "HTTP/1.1 #{@response_code} OK\r\n" +
                   "Content-Type: application/json\r\n" +
                   "Content-Length: #{@response_body.bytesize}\r\n" +
                   "Connection: close\r\n\r\n"

      socket.print @response_body
      socket.close
    end
  end
  def close
    @server.close
  end
  def self.run_test_servers
    return unless @@threads.empty?

    servers = Array.new
    servers.push TestHttpServer.new
    servers.push TestHttpServer.new(11002,200,'{"status": "current", "severity": "none"}')
    servers.push TestHttpServer.new(11003,200,'{"status": "bad-status", "severity": "high"}')
    servers.push TestHttpServer.new(11004,200,'{"status": "out-of-date", "severity": "bad-severity"}')
    servers.push TestHttpServer.new(11005,200,'')
    servers.push TestHttpServer.new(11006,200,'this is not valid json')

    servers.each { | s | @@threads.push Thread.new { s.run } }
    sleep 1
  end
  def self.wait_on_threads
    @@threads.each { | t | t.join }
  end
end
