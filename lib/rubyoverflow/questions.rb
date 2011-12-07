module Rubyoverflow
  class Questions < Base
    def initialize(client)
      set_path('questions')
      super(client)
    end
  end
end
