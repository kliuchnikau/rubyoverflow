module Rubyoverflow
  class Base
    def initialize(client)
      @client = client
    end

    def fetch(params = {})
			get_response params
    end

    def method_missing(name, *args, &block)
      params = args.first
			get_response params, name
		end

    protected

		def get_response params, aspect = nil
			ids = params.delete(:id) if params[:id]
			ids = ids.join(';') if ids and ids.kind_of? Array
			request_path = "#{@path}#{"/#{ids}" if ids}"
			request_path << "/#{aspect}" if aspect
			hash, url = @client.request request_path, params
			Hashie::Mash.new hash
		end

    def set_path(pa)
      @path = pa
    end
  end
end