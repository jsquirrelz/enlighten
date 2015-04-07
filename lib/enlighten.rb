require 'json'
require 'net/http'
require_relative 'utils'

module Enlighten
  class System
    include Utils
    @default_params = {
        host: 'api.enphaseenergy.com',
        path: '/api/v2/systems'
    }

    class << self
      def config(args={})
        @default_params = @default_params.merge(args).freeze unless args.empty?
        @default_params
      end
      # Allows to set defaults through app configuration:
      #
      #    config.action_mailer.default_options = { from: "no-reply@example.org" }
      alias :default_options= :config
    end

    def method_missing(method,*args)
      fetch(method, args[0])
    end

    def initialize(id)
      @id = id
    end

    def self.find(id)
      new(id)
    end

    def self.default_params
      @default_params
    end

    def self.url
      "https://#{@default_params[:host]}#{@default_params[:path]}"
    end

protected
    def fetch(method, args={})
      OpenStruct.new(JSON.parse(api_response(method,args)))
    end

    def api_response(method,args={})
      Net::HTTP.get(URI(format_url(method,args)))
    end

    def format_url(method,args={})
      params = {key: self.class.default_params[:key], user_id: self.class.default_params[:user_id]}.merge(args||{})
      self.class.url + '/' +  method.to_s + '?' + query_string(params)
    end
  end
end
