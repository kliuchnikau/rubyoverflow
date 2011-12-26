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
		# methods are named according to Enumerable#each_* naming convention
		describe '#each_fetch' do
			it 'yields block for each page' do
				paqes = []
				@client.users.each_fetch(:id => [53587, 22656, 23354], :pagesize => 2) { |page_result|
					paqes << page_result
				}

				paqes.should have(2).items

				paqes[0].page.should == 1
				paqes[1].page.should == 2
			end

			it 'should start iterating from :page parameter (when specified)' do
				pages = []
				@client.users.each_fetch(:id => [53587, 22656, 23354], :pagesize => 2, :page => 2) { |page_result|
					pages << page_result
				}

				pages.should have(1).item

				pages[0].page.should == 2
			end

			it 'should ignore requests with :pagesize = 0' do
				expect { @client.users.each_fetch(:pagesize => 0) {} }.should_not raise_error
			end

			it 'should return self if block given' do
				@client.users.each_fetch(:id => 53587) {}.should equal @client.users
			end

			it 'should return Enumerator if no block given' do
				enum = @client.users.each_fetch(:id => 53587)

				enum.should be_an_instance_of Enumerator

				pages = []
				enum.each { |page| pages << page }

				pages.should have(1).page
				pages[0].should have(1).users
				pages[0].users[0].user_id.should == 53587
			end
		end

		describe '#each_{method_missing}' do
			def fake_page total, page = 1, pagesize = 30
				{'total' => total, 'page' => page, 'pagesize' => pagesize }
			end

			let(:users_client) do
				client = mock("Rubyoverflow::Client")
				client.should_receive(:request).with('users/53587/questions', {}).and_return(fake_page(54))
				client.should_receive(:request).with('users/53587/questions', {:page => 2}).and_return(fake_page(54, 2))
				client

				Rubyoverflow::Users.new(client)
			end

			it 'should iterate for each page' do
				paqes = []
				users_client.each_questions(:id => [53587]) {|page| paqes << page}

				paqes.should have(2).items

				paqes[0].page.should == 1
				paqes[1].page.should == 2
			end
		end
	end
end