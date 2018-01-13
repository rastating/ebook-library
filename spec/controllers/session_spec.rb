require_relative '../spec_helper'
require 'app/controllers/session'

describe EBL::Controllers::Session do
  let(:app) { described_class }

  before(:each) do
    user = EBL::Models::User.new
    user.username = 'test'
    user.create_password_hash 'test'
    user.save
  end

  describe 'GET /' do
    context 'when user is logged in' do
      it 'sets status code to 200' do
        get '/', {}, 'rack.session' => { user_id: 1 }
        expect(last_response.status).to eq 200
      end

      it 'sends the user as json' do
        get '/', {}, 'rack.session' => { user_id: 1 }
        data = JSON.parse(last_response.body)
        expect(data['id']).to eq 1
        expect(data['username']).to eq 'test'
        expect(data['locked']).to be false
      end
    end

    context 'when user is not logged in' do
      it 'sets status code to 404' do
        get '/'
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'POST /' do
    context 'when the body is not valid JSON' do
      it 'sets status code to 500' do
        post '/', 'invalid'
        expect(last_response.status).to eq 500
      end

      it 'sends a JSON object with an error message' do
        post '/', 'invalid'
        data = JSON.parse(last_response.body)
        expect(data['error']).to be true
        expect(data['message']).to eq 'Malformed body'
      end
    end

    context 'when an invalid username or password is sent' do
      it 'sets status code to 404' do
        post '/', '{ "username": "test", "password": "a" }'
        expect(last_response.status).to eq 404
      end
    end

    context 'when a valid username and password is sent' do
      it 'sets the user_id session variable' do
        post '/', '{ "username": "test", "password": "test" }'
        expect(last_request.env['rack.session'][:user_id]).to eq 1
      end

      it 'sends the user as json' do
        post '/', '{ "username": "test", "password": "test" }'
        data = JSON.parse(last_response.body)
        expect(data['id']).to eq 1
        expect(data['username']).to eq 'test'
        expect(data['locked']).to be false
      end
    end
  end

  describe 'DELETE /' do
    it 'unsets the user_id session variable' do
      post '/', '{ "username": "test", "password": "test" }'
      session = last_request.env['rack.session']
      expect(session[:user_id]).to eq 1

      delete '/', {}, 'rack.session' => session
      expect(last_request.env['rack.session'][:user_id]).to be_nil
    end

    it 'sets status to 200' do
      delete '/'
      expect(last_response.status).to eq 200
    end
  end

  it_behaves_like 'a route controller'
end
