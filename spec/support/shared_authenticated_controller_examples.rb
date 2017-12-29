RSpec.shared_examples 'an authenticated route controller' do
  context 'when the user is not logged in' do
    it 'the response code is set to 401' do
      get '/'
      expect(last_response.status).to eq 401
    end

    it 'the response body is blank' do
      get '/'
      expect(last_response.body).to eq ''
    end
  end

  context 'when the user is logged in' do
    it_behaves_like 'a route controller', username: 'username'
  end
end
