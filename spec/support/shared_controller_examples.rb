RSpec.shared_examples 'a route controller' do |session|
  context 'when requesting a route that does not exist' do
    it 'returns a json object with not_found and error set to true' do
      get '/a/route/that/does/not/exist', {}, 'rack.session' => session
      expect(last_response.body).to eq '{"error":true,"not_found":true}'
    end

    it 'sets the response code to 404' do
      get '/a/route/that/does/not/exist', {}, 'rack.session' => session
      expect(last_response.not_found?).to be true
    end
  end
end
