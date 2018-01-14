require_relative '../spec_helper'
require 'app/controllers/books'

describe EBL::Controllers::Books do
  let(:app) { described_class }

  before(:each) do
    EBL::Models::Book.create(
      title: 'test',
      description: 'test',
      drm_protected: false,
      path: '/path/to/book.epub',
      cover_path: '/path/to/cover.jpg'
    )

    EBL::Models::Book.create(
      title: 'test2',
      description: 'test2',
      drm_protected: false,
      path: '/path/to/book2.epub',
      cover_path: '/path/to/cover.jpg'
    )
  end

  describe 'GET /' do
    it 'sends all books as a JSON array' do
      get '/', {}, 'rack.session' => { user_id: 1 }
      data = JSON.parse(last_response.body)
      expect(data.length).to eq 2
      expect(data[0]['title']).to eq 'test'
      expect(data[1]['title']).to eq 'test2'
    end
  end

  describe 'GET /:id' do
    context 'when the book id is invalid' do
      it 'sets status to 404' do
        get '/999', {}, 'rack.session' => { user_id: 1 }
        expect(last_response.status).to eq 404
      end
    end

    context 'when the book id is valid' do
      it 'sends the book as a JSON object' do
        get '/1', {}, 'rack.session' => { user_id: 1 }
        data = JSON.parse(last_response.body)
        expect(data['title']).to eq 'test'
        expect(data['id']).to eq 1
      end
    end
  end

  describe 'GET /:id/cover/:filename' do
    it 'sends the cover' do
      EBL::Models::Setting.create(key: 'covers_path', value: '/covers/path')
      sent_file = false

      allow_any_instance_of(app).to receive(:send_file) do |_t, p1|
        sent_file = p1 == '/covers/path/path/to/cover.jpg'
      end

      get '/1/cover/cover.jpg', {}, 'rack.session' => { user_id: 1 }
      expect(sent_file).to be true
    end
  end

  describe 'GET /:id/epub/:filename' do
    it 'sends the epub file' do
      sent_file = false

      allow_any_instance_of(app).to receive(:send_file) do |_t, p1|
        sent_file = p1 == '/path/to/book.epub'
      end

      get '/1/epub/book.epub', {}, 'rack.session' => { user_id: 1 }
      expect(sent_file).to be true
    end
  end

  it_behaves_like 'an authenticated route controller'
end
