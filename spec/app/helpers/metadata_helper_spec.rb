require_relative '../../spec_helper'
require 'app/helpers/metadata_helper'

describe EBL::Helpers::MetadataHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::MetadataHelper
    end.new
  end

  let(:epub_dbl) { double('epub') }

  before(:each) do
    allow(EPUBInfo).to receive(:get).and_return epub_dbl
  end

  describe '#extract_authors_from_epub' do
    context 'when no authors can be found' do
      it 'returns a blank array' do
        allow(epub_dbl).to receive(:creators).and_return []
        expect(subject.extract_authors_from_epub('/epub')).to eq []
      end
    end

    context 'when the ePub contains a list of authors' do
      it 'returns an array of EBL::Models::Author' do
        authors = [
          double('author', name: 'author1'),
          double('author', name: 'author2')
        ]

        allow(epub_dbl).to receive(:creators).and_return authors

        result = subject.extract_authors_from_epub('/epub')
        expect(result.length).to eq 2
        expect(result[0]).to be_a EBL::Models::Author
        expect(result[1]).to be_a EBL::Models::Author
        expect(result[0].name).to eq 'author1'
        expect(result[1].name).to eq 'author2'
      end
    end
  end
end
