require File.dirname(__FILE__) + "/spec_helper"

describe Stats do
  before(:each) do
    @client = Client.new
  end

  it "retrieves stats" do
    result = @client.stats.fetch
    result.should respond_to(:statistics)
  end
end
