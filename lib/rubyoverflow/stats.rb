module Rubyoverflow
  class Stats < Base
    def initialize(client)
      set_path('stats')
      super(client)
    end
  end
end
