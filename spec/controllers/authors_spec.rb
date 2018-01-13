require_relative '../spec_helper'
require 'app/controllers/authors'

describe EBL::Controllers::Authors do
  let(:app) { described_class }

  before(:each) do
    author = EBL::Models::Author.create(name: 'test')
    EBL::Models::Author.create(name: 'test2')

    book = EBL::Models::Book.create(
      title: 'test',
      description: 'test',
      drm_protected: false,
      path: '/path/to/epub'
    )

    book.add_author(author)
  end

  describe 'GET /' do
    it 'sends all authors as a JSON array' do
      get '/', {}, 'rack.session' => { user_id: 1 }
      data = JSON.parse(last_response.body)
      expect(data.length).to eq 2
      expect(data[0]['name']).to eq 'test'
      expect(data[1]['name']).to eq 'test2'
    end
  end

  describe 'GET /:id' do
    context 'when the author id is invalid' do
      it 'sets status to 404' do
        get '/999', {}, 'rack.session' => { user_id: 1 }
        expect(last_response.status).to eq 404
      end
    end

    context 'when the author id is valid' do
      it 'sends the author as a JSON object' do
        get '/1', {}, 'rack.session' => { user_id: 1 }
        data = JSON.parse(last_response.body)
        expect(data['name']).to eq 'test'
        expect(data['id']).to eq 1
      end
    end
  end

  it_behaves_like 'an authenticated route controller'
end
