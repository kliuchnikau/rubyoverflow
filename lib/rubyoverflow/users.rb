module Rubyoverflow
  class Users < Base
    def initialize(client)
      set_path('users')
      super(client)
    end
  end
end
