module Rubyoverflow
  class Base
    def initialize(client)
      @client = client
    end

    def fetch(params = {})
			get_response params
    end

		def each_fetch(params = {})
			first_page_res = fetch(params)
			yield first_page_res

			total, first_page, pagesize = first_page_res.total, first_page_res.page, first_page_res.pagesize
			return if pagesize == 0
			last_page = (total / pagesize) + ( total % pagesize != 0 ? 1 : 0)

			(first_page+1..last_page).each { |p| yield fetch params.merge(:page => p) }
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