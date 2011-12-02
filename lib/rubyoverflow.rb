path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'httparty'
require 'ostruct'

require 'hashie'
require 'json'
require 'rubyoverflow/base'
require 'rubyoverflow/sites'
require 'rubyoverflow/users'
require "rubyoverflow/version"

module Rubyoverflow
  class Client
    include HTTParty
    format :plain
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
      parameters['key'] = @api_key unless @api_key.nil? || @api_key.empty?
      url = "#{host_path}#{normalize(path)}"
      response = self.class.get url, :query => parameters, :headers => {"Accept-Encoding" => "gzip"}

      charset = retrieve_charset(response)

      p charset

      return JSON.parse(response.body), url
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
      path.end_with?('/') ? path : path+ '/'
    end

    def retrieve_charset(response)
      charset = response.headers["content-type"].split(";").select{ |c| c =~ /charset/ }.first

      if charset and !charset.strip.empty?
        charset.split("=").last
      else
        nil
      end
    end
  end
end
