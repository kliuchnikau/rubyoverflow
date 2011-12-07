require File.dirname(__FILE__) + "/spec_helper"

describe Questions do
  before(:each) do
    @client = Client.new
  end

  it "retrieves questions" do
    result = @client.questions.fetch
    result.should respond_to(:questions)
    result.page.should == 1
  end
end
