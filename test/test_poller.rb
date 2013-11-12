require 'test/unit'
require 'polycom/poller'

class PollerTest < Test::Unit::TestCase
  
  def setup
    @poller = Polycom::Poller.new(:username => 'admin', :password => '456', :ip_address => '1.2.3.4')
  end
  
  def test_poller_creation
    assert_equal @poller.username, 'admin'
  end

  def test_poller_call
    "YES"
  end
  
end
