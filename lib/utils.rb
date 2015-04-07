require 'cgi'
module Utils
  def query_string(args)
    args.map{|k,v|"#{k.to_s}=#{CGI.escape(date_format(v))}"}.join('&')
  end
  def date_format(date)
    date ? (date.respond_to?(:strftime)?date.strftime('%Y-%m-%d'):date.to_s) : ''
  end
end