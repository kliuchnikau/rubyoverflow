path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'faraday'
require 'ostruct'
require 'zlib'

require 'hashie'
require 'json'
require 'rubyoverflow/base'
require 'rubyoverflow/sites'
require 'rubyoverflow/users'
require "rubyoverflow/version"

module Rubyoverflow
  class Client
    HOST = 'http://api.stackoverflow.com'
    VERSION = '1.1'

    Rubyoverflow.constants.select {|c| Class === Rubyoverflow.const_get(c) and Rubyoverflow.const_get(c) < Rubyoverflow::Base}.each do |class_sym|
      send :attr_reader, class_sym.downcase
      send "define_method", class_sym.downcase do
        instance_variable_set("@#{class_sym.downcase}", Rubyoverflow.const_get(class_sym).new(self)) unless instance_variable_get("@#{class_sym.downcase}")
        instance_variable_get "@#{class_sym.downcase}"
      end
    end

    attr_accessor :host
    attr_accessor :api_key

    def initialize(options = OpenStruct.new)
      if options.kind_of? OpenStruct
        @host = options.host || HOST
        @version = options.version || VERSION
        @api_key = options.api_key if options.api_key
      end
    end

    def request(path, parameters = {})
      conn = Faraday.new(:url => host_path) do |builder|
        builder.request  :url_encoded
        builder.request  :json
        builder.adapter  :net_http
      end
      parameters[:key] = @api_key unless @api_key.nil? || @api_key.empty?
      parameters['Accept-Encoding'] = 'gzip'
      response = conn.get do |req|
        req.url normalize(path), parameters
      end
      rep_string = response.body
      begin
        gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
        rep_string = gz.read
      rescue Zlib::GzipFile::Error
      end
      return JSON.parse(rep_string), response.env[:url]
    end

    def host_path
      "#{normalize(@host)}#{normalize(@version)}"
    end

    class << self
      def stackauth_client(api_key = '')
        options = OpenStruct.new
        options.host = 'http://stackauth.com/'
        options.api_key = api_key if api_key
        Client.new options
      end
    end

    private

    def normalize(path)
      path.end_with?('/') ? path : path + '/'
    end
  end
end
