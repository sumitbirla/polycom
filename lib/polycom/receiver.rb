require 'sinatra'
require 'active_support/core_ext/hash'
require 'yaml'


module Polycom

  class Receiver < Sinatra::Base

    set :bind, '0.0.0.0'
    set :logging, false

    post '/' do
      puts Hash.from_xml(request.body.read).to_yaml
    end
  
  end

end
