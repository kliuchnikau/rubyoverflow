module Rubyoverflow
  class Answers < Base
    def initialize(client)
      set_path('answers')
      super(client)
    end
  end
end
