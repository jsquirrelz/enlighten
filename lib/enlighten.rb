require 'json'
require 'net/http'
require 'digest'

module Enlighten
  class EnlightenError < StandardError
  end
  class EnlightenApiError < EnlightenError
    attr_reader :code
    def initialize(json)
        @code = json.reason.to_i if json.reason.to_i
        super((json.message && json.message.join('; ')) || json.reason)
    end
  end

  class System
    @default_params = {
        host: 'api.enphaseenergy.com',
        path: '/api/v2/systems',
        time_zone: 7
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
      @attributes[method.to_s + Digest::MD5.base64digest(args[0].to_s)] ||= fetch(method, args[0])
    end

    def initialize(id)
      @id = id
      @attributes = {}
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
      result = OpenStruct.new(JSON.parse(api_response(method,args)))
      raise(EnlightenApiError.new(result)) if result.respond_to?(:reason)
      result
    end

    def api_response(method,args={})
      Net::HTTP.get(URI(format_url(method,args)))
    end

    def format_url(method,args={})
      params = {key: self.class.default_params[:key], user_id: self.class.default_params[:user_id]}.merge(args||{})
      self.class.url + '/' +  @id.to_s + '/' + method.to_s + '?' + query_string(params)
    end
    def query_string(args)
      args.map{|k,v|value= (['start_at','end_at'].include? k.to_s)  ? v.to_i.to_s : date_format(v);"#{k.to_s}=#{CGI.escape(value)}"}.join('&')
    end
    def date_format(date)
      date ? (date.respond_to?(:strftime)?date.strftime('%Y-%m-%d'):date.to_s) : ''
    end

  end
end
