module Rubyoverflow
  class Base
    def initialize(client)
      @client = client
    end

    def fetch(params = {})
			get_response params
    end

		def each_fetch(params = {}, &block)
			get_each_response(params, &block)
		end

    def method_missing(name, *args, &block)
			params = args.first
			each_prefix = 'each_'
			if name.to_s.start_with? each_prefix
				aspect = name[each_prefix.length..-1]
				get_each_response params, aspect, &block
			else
				get_response params, name
			end
		end

    protected

		def get_response in_params, aspect = nil
			params = in_params.clone # in order not to remove :id from original input parameter
			ids = params.delete(:id) if params[:id]
			ids = ids.join(';') if ids and ids.kind_of? Array
			request_path = "#{@path}#{"/#{ids}" if ids}"
			request_path << "/#{aspect}" if aspect
			hash, url = @client.request request_path, params
			Hashie::Mash.new hash
		end

		def get_each_response params, aspect = nil, &block
			return enum_for(:each_fetch, params) unless block_given?

			first_page_res = get_response(params, aspect)
			yield first_page_res

			total, first_page, pagesize = first_page_res.total, first_page_res.page, first_page_res.pagesize
			return if pagesize == 0
			last_page = (total / pagesize) + (total % pagesize != 0 ? 1 : 0)

			(first_page+1..last_page).each { |p| yield get_response(params.merge(:page => p), aspect) }

			self
		end

    def set_path(pa)
      @path = pa
    end
  end
end