module Rubyoverflow
  class Sites
    @client = nil
    def fetch(params = {})
      @client ||= Client.stackauth_client
      hash,url = @client.request 'sites', params
      Hashie::Mash.new hash
    end
  end

  class Client
    @sites = nil

    def sites
      @sites ||= Sites.new
    end
  end
end
