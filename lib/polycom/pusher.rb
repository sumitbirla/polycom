require 'uri'
require 'net/http'
require 'net/http/digest_auth'

module Polycom

  class Pusher
    attr_accessor :username, :password, :ip_address
  
    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  
  
    def send(h)
      priority = h.fetch(:priority, :critical).to_s.capitalize
      data = h.fetch(:data, nil)
      url = h.fetch(:url, nil)
      
      if data.nil? && url.nil?
        raise "Either :data or :url must be passed to this method"
      end
      
      push_data(priority, data) unless data.nil?
      push_url(priority, url) unless url.nil?
    end
  
  
    private
    
      def push_data(priority, data)
        resp = send_http "<PolycomIPPhone><Data priority=\"#{priority}\">#{data}</Data></PolycomIPPhone>"
        raise "Polycom phone at #{@ip_address} said: [#{resp.code}] #{resp.message}" unless resp.code == '200'
      end
    
    
      def push_url(priority, url)
        resp = send_http "<PolycomIPPhone><URL priority=\"#{priority}\">#{url}</URL></PolycomIPPhone>", true
        raise "Polycom phone at #{@ip_address} said: [#{resp.code}] #{resp.message}" unless resp.code == '200'
      end
      
  
      def send_http(data, url = false)
        digest_auth = Net::HTTP::DigestAuth.new
    
        uri = URI.parse("http://#{@ip_address}/push")
        uri.user = @username
        uri.password = @password

        h = Net::HTTP.new uri.host, uri.port
        req = Net::HTTP::Post.new uri.request_uri
        res = h.request req

        auth = digest_auth.auth_header(uri, res['www-authenticate'], 'POST')
        req = Net::HTTP::Post.new(uri.request_uri)
        req.add_field 'Authorization', auth
        req.add_field 'Content-Type', 'application/x-com-polycom-spipx' if url
        req.body = data

        resp = h.request(req)
      end

  end

end
