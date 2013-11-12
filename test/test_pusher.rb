require 'test/unit'
require 'polycom/pusher'

class PusherTest < Test::Unit::TestCase
  
  def setup
    @pusher = Polycom::Pusher.new(:username => 'admin', :password => '456', :ip_address => '1.2.3.4')
  end
  
  def test_pusher_creation
    assert_equal @pusher.username, 'admin'
  end

  def test_pusher_call
    "YES"
  end
  
end
