require 'ostruct'
require 'uri'
require 'net/http'
require 'net/http/digest_auth'
require 'rexml/document'

module Polycom

  class Poller
    attr_accessor :username, :password, :ip_address
  
    def initialize(args)
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
      
    def device_information
      xml = fetch_xml('deviceHandler')
      node = xml.elements["PolycomIPPhone/DeviceInformation"]
    
      h = {}
      h[:mac_address] = node.elements["MACAddress"].text
      h[:phone_dn] = node.elements["PhoneDN"].text
      h[:app_load_id] = node.elements["AppLoadID"].text
      h[:updater_id] = node.elements["UpdaterID"].text
      h[:model_number] = node.elements["ModelNumber"].text
      h[:timestamp] = node.elements["TimeStamp"].text
    
      h
    end
  
    def network_information
      xml = fetch_xml('networkHandler')
      node = xml.elements["PolycomIPPhone/NetworkConfiguration"]
    
      h = {}
      h[:dhcp_server] = node.elements["DHCPServer"].text
      h[:mac_address] = node.elements["MACAddress"].text
      h[:dns_suffix] = node.elements["DNSSuffix"].text
      h[:ip_address] = node.elements["IPAddress"].text
      h[:subnet_mask] = node.elements["SubnetMask"].text
      h[:provisioning_server] = node.elements["ProvServer"].text
      h[:default_router] = node.elements["DefaultRouter"].text
      h[:dns_server1] = node.elements["DNSServer1"].text
      h[:dns_server2] = node.elements["DNSServer2"].text
      h[:vlan_id] = node.elements["VLANID"].text
      h[:dhcp_enabled] = node.elements["DHCPEnabled"].text
    
      h
    end
  
    def call_line_info
      xml = fetch_xml('callstateHandler')
      list = []
  
      xml.elements.each('PolycomIPPhone/CallLineInfo') do |node|
        h = {}
        h[:line_key_num] = node.elements["LineKeyNum"].text
        h[:line_dir_num] = node.elements["LineDirNum"].text
        h[:line_state] = node.elements["LineState"].text
        
        unless node.elements["CallInfo"].nil?
          h[:call_info] = {}
          h[:call_info][:call_state] = node.elements["CallInfo/CallState"].text
          h[:call_info][:call_type] = node.elements["CallInfo/CallType"].text
          h[:call_info][:ui_appearance_index] = node.elements["CallInfo/UIAppearanceIndex"].text
          h[:call_info][:called_party_name] = node.elements["CallInfo/CalledPartyName"].text
          h[:call_info][:called_party_dir_num] = node.elements["CallInfo/CalledPartyDirNum"].text
          h[:call_info][:calling_party_name] = node.elements["CallInfo/CallingPartyName"].text
          h[:call_info][:calling_party_dir_num] = node.elements["CallInfo/CallingPartyDirNum"].text
          h[:call_info][:call_reference] = node.elements["CallInfo/CallReference"].text
          h[:call_info][:call_duration] = node.elements["CallInfo/CallDuration"].text
        end
      
        list << h
      end
  
      list
    end
  
  
    private
  
      def fetch_xml(slug)
        digest_auth = Net::HTTP::DigestAuth.new
    
        uri = URI.parse("http://#{@ip_address}/polling/#{slug}")
        uri.user = @username
        uri.password = @password

        h = Net::HTTP.new uri.host, uri.port
        req = Net::HTTP::Get.new uri.request_uri
        res = h.request req

        auth = digest_auth.auth_header(uri, res['www-authenticate'], 'GET')
        req = Net::HTTP::Get.new(uri.request_uri)
        req.add_field 'Authorization', auth
        #req.add_field 'Content-Type', 'application/x-com-polycom-spipx'

        resp = h.request(req)
        doc = REXML::Document.new(resp.body)
      end
  
  end

end
