require File.dirname(__FILE__) + "/spec_helper"

describe Users do
  before(:each) do
    @client = Client.new
  end

  it "retrieves users" do
    result = @client.users.fetch
    result.should respond_to(:users)
    result.page.should == 1
  end

  it "retrieves Dan Seaver" do
    result = @client.users.fetch(:id => 53587)
    result.users.first.display_name.should == 'Dan Seaver'
  end

  it "retrieves multiple users by an array of ids" do
    result = @client.users.fetch(:id => [53587,22656])
    result.total.should == 2
	end

	context 'when request several pages' do
		# methods named according to Enumerable#each_* naming convention
		describe '#each_fetch' do
			it 'yields block for each page' do
				results = []
				@client.users.each_fetch(:id => [53587, 22656, 23354], :pagesize => 2) { |page_result|
					results << page_result
				}

				results.should have(2).items

				results[0].page.should == 1
				results[1].page.should == 2
			end

			it 'should start iterating from :page parameter (when specified)'

			it 'should ignore requests with :pagesize = 0'
		end

		describe '#each_{method_missing}' do

		end
	end
end