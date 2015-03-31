require "enlighten/version"
require 'json'
require 'net/http'
module Enlighten
  class System

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
      @attributes[method.to_sym] ||= fetch(method)
    end

    def initialize(id)
      @id = id
      @attributes = {}
      @attributes[:summary] = fetch(:summary)
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


    def fetch(method)
      OpenStruct.new(JSON.parse(Net::HTTP.get(URI(format_url(method)))))
    end

    def format_url(method)
      self.class.url + '/' + @id.to_s + '/' + method.to_s + "?key=#{self.class.default_params[:key]}&user_id=#{self.class.default_params[:user_id]}"
    end
  end
end
