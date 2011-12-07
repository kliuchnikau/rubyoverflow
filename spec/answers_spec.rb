require File.dirname(__FILE__) + "/spec_helper"

describe Answers do
  before(:each) do
    @client = Client.new
  end

  it "retrieves answers" do
    result = @client.answers.fetch
    result.should respond_to(:answers)
    result.page.should == 1
  end
end
