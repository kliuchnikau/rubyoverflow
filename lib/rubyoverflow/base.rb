module Rubyoverflow
  class Base
    def initialize(client)
      @client = client
    end

    def fetch(params = {})
      ids = params.delete(:id) if params[:id]
      ids = ids.join(';') if ids and ids.kind_of? Array
      hash,url = @client.request "#{@path}#{"/#{ids}" if ids}", params

      Hashie::Mash.new hash
    end

    def method_missing(name, *args, &block)
      params = args.first
      ids = params.delete(:id) if params[:id]
      ids = ids.join(';') if ids and ids.kind_of? Array
      hash,url = @client.request "#{@path}#{"/#{ids}" if ids}/#{name}", params
    end

    protected

    def set_path(pa)
      @path = pa
    end

  end
end
