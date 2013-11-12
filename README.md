# Polycom

This gem is used for communicating with IP Polycom phones using their XML application interface.  It was tested with 
the following phones:

* Polycom VVX 410

However, this gem should work with other phones as well.  


## Installation

Add this line to your application's Gemfile:

    gem 'polycom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polycom
    


## Using in ruby code

There are two classes available for you to query information and push data to your phone:

### Poller

This class implements three methods for fetching various pieces of information:

```ruby
  poller = Polycom::Poller.new (
			:username => 'admin',
			:password => '456',
			:ip_address => '10.0.5.7' )

  puts poller.device_information
  puts poller.network_information
  puts poller.call_line_info
```


### Pusher 

This class is used for pushing HTML data or URL to the phone.

```ruby
  pusher = Polycom::Pusher.new (
			:username => 'admin', 
			:password => '456', 
			:ip_address => '10.0.5.7' )

  pusher.send(:priority => :important, :data => "Hello NSA!")
  pusher.send(:priority => :important, :url => "/index.html")
```



## Command Line Usage

This gem is bundled with an executable called `polycom`. Simplest usage is the following:

<pre>
% polycom admin:456@10.0.5.7 -i

Device Information
--------------------
  mac_address         :	 0004fa839af9
  phone_dn            :	 Line1:3000
  app_load_id         :	 4.1.4.7430 20-Mar-13 14:12
  updater_id          :	 5.1.4.0844
  model_number        :	 VVX 410
  timestamp           :	 2013-10-21T14:24:38-05:00


Network Information
--------------------
  dhcp_server         :	 10.0.5.1
  mac_address         :	 0004fa839af9
  dns_suffix          :	 example.com
  ip_address          :	 10.0.5.7
  subnet_mask         :	 255.255.0.0
  provisioning_server :	 10.0.5.2037
  default_router      :	 10.0.5.7
  dns_server1         :	 8.8.4.4
  dns_server2         :	 0.0.0.0
  vlan_id             :	 
  dhcp_enabled        :	 Yes


Call Line Information
-----------------------
  -
  line_key_num        :	 1
  line_dir_num        :	 3000
  line_state          :	 Inactive
  -
</pre>


#### Displaying a message on the phones browser

<pre>
% polycom admin:456@10.0.5.7 -data critical "&lt;h1&gt;Hello World&lt;/h1&gt;"
</pre>


#### Pushing a URL to be displayed on the phone

You must set the `apps.push.serverRootURL` value in the 
phone's configuration.  The URL you send will be appended to this value.

<pre>
% polycom admin:456@10.0.5.7 -url important "/index.html"
</pre>


#### Receiving notifications from the phone

This requires you to configure `apps.telNotification.URL` in the 
phones configuration to the URL printed upon running this commant.  polycom somes with a built in web 
server to received and print notifications.

<pre>

% polycom admin:456@10.0.5.7 -n


IMPORTANT:
Set up your Polycom phone to send 'Telephony Event Notification' to http://1.2.3.4:4567.
Please CRTL-C to end this script.

[2013-10-23 13:48:19] INFO  WEBrick 1.3.1
[2013-10-23 13:48:19] INFO  ruby 2.0.0 (2013-05-14) [x86_64-linux]
== Sinatra/1.4.3 has taken the stage on 4567 for development with backup from WEBrick
[2013-10-23 13:48:19] INFO  WEBrick::HTTPServer#start: pid=32608 port=4567
---
PolycomIPPhone:
  CallStateChangeEvent:
    CallReference: 41aa9c00
    CallState: Dialtone
    PhoneIP: 10.0.5.7
    MACAddress: 0004f2839af9
    TimeStamp: '2013-10-23T13:50:56-05:00'
    CallLineInfo:
      LineKeyNum: '1'
      LineDirNum: '1006'
      LineState: Active
      CallInfo:
        CallReference: 41aa9c00
        CallState: Dialtone
        CallType: Outgoing
        UIAppearanceIndex: 1*
        CalledPartyName: 
        CalledPartyDirNum: 
        CallingPartyName: '1006'
        CallingPartyDirNum: sip:1006@example.com
        CallDuration: '0'
</pre>



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
