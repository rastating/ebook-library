require_relative '../../spec_helper'
require 'app/jobs/epub_scan_job'

describe EBL::Jobs::EpubScanJob do
  let(:subject) { described_class.new }

  describe '#create_book' do
    context 'when validation fails' do
      it 'returns nil and logs the errors' do
        logged_error = false

        book = EBL::Models::Book.new
        book.drm_protected = true
        book.title = 'title'

        allow(EBL::Models::Book).to receive(:from_epub).and_return book
        allow(subject).to receive(:log_error) do |p1|
          logged_error = !/Failed to validate book/.match(p1).nil?
        end

        expect(subject.create_book('/test', :epub)).to be_nil
        expect(logged_error).to be true
      end
    end

    context 'when a valid book is created' do
      it 'returns the book model' do
        book = EBL::Models::Book.new
        book.drm_protected = true
        book.title = 'title'
        book.description = 'desc'
        book.path = '/test'

        allow(EBL::Models::Book).to receive(:from_epub).and_return book
        allow(subject).to receive(:log_error).and_return true
        allow(subject).to receive(:extract_authors_from_epub).and_return []

        result = subject.create_book('/path/to/epub', :epub)

        expect(result.id).to_not be_nil
        expect(result.title).to eq 'title'
        expect(EBL::Models::Book.count).to eq 1
      end
    end
  end

  describe '#import_book' do
    context 'when the book fails to import into the database' do
      it 'logs an error' do
        logged_error = false

        allow(subject).to receive(:create_book).and_return nil
        allow(subject).to receive(:log_error) do |p1|
          logged_error = (p1 == 'Failed to import /path/to/epub')
        end

        subject.import_book '/path/to/epub', :epub
        expect(logged_error).to be true
      end
    end

    context 'when the epub file fails to copy into the library' do
      it 'logs an error' do
        logged_error = false

        allow(subject).to receive(:create_book).and_return true
        allow(subject).to receive(:copy_book_to_library).and_return false
        allow(subject).to receive(:log_error) do |p1|
          logged_error = (p1 == 'Failed to import /path/to/epub')
        end

        subject.import_book '/path/to/epub', :epub
        expect(logged_error).to be true
      end
    end

    context 'when the book imports successfully' do
      it 'logs the operation result' do
        logged_message = false
        book = double('book', title: 'title', id: 1)

        allow(EBL::Jobs::RefreshMetadataJob).to receive(:perform_async).and_return true
        allow(subject).to receive(:create_book).and_return book
        allow(subject).to receive(:copy_book_to_library).and_return true
        allow(subject).to receive(:log_green) do |p1|
          logged_message = (p1 == 'Imported title [ID:1]')
        end

        subject.import_book '/path/to/epub', :epub
        expect(logged_message).to be true
      end

      it 'queues a metadata refresh job' do
        job_queued = false
        book = double('book', title: 'title', id: 1)

        allow(subject).to receive(:create_book).and_return book
        allow(subject).to receive(:copy_book_to_library).and_return true
        allow(subject).to receive(:log_green).and_return true

        allow(EBL::Jobs::RefreshMetadataJob).to receive(:perform_async) do
          job_queued = true
        end

        subject.import_book '/path/to/epub', :epub
        expect(job_queued).to be true
      end
    end
  end

  describe '#process_file' do
    context 'when the file path is a directory' do
      it 'queues another scan job' do
        job_queued = false

        allow(subject).to receive(:scan_path).and_return '/'
        allow(File).to receive(:directory?).and_return true
        allow(EBL::Jobs::EpubScanJob).to receive(:perform_async) do
          job_queued = true
        end

        subject.process_file '/path/to/directory'
        expect(job_queued).to be true
      end
    end

    context 'when the file path is a file' do
      context 'is an epub, and has not been imported before' do
        it 'imports the book' do
          imported = false

          allow(File).to receive(:directory?).and_return false
          allow(EBL::Models::ImportLog).to receive(:imported?).and_return false

          allow(subject).to receive(:scan_path).and_return '/'
          allow(subject).to receive(:epub?).and_return true
          allow(subject).to receive(:import_book) do
            imported = true
          end

          subject.process_file '/path/to/directory'
          expect(imported).to be true
        end
      end

      context 'when the file is not an epub' do
        it 'does not import the book' do
          imported = false

          allow(File).to receive(:directory?).and_return false
          allow(EBL::Models::ImportLog).to receive(:imported?).and_return false

          allow(subject).to receive(:scan_path).and_return '/'
          allow(subject).to receive(:epub?).and_return false
          allow(subject).to receive(:import_book) do
            imported = true
          end

          subject.process_file '/path/to/directory'
          expect(imported).to be false
        end
      end

      context 'when the file has already been imported' do
        it 'does not import the book' do
          imported = false

          allow(File).to receive(:directory?).and_return false
          allow(EBL::Models::ImportLog).to receive(:imported?).and_return true

          allow(subject).to receive(:scan_path).and_return '/'
          allow(subject).to receive(:epub?).and_return true
          allow(subject).to receive(:import_book) do
            imported = true
          end

          subject.process_file '/path/to/directory'
          expect(imported).to be false
        end
      end
    end
  end

  describe '#perform' do
    it 'creates a logger with the job:scan context' do
      allow_any_instance_of(EBL::Logger).to receive(:log).and_return true
      allow(subject).to receive(:process_file).and_return true
      allow(Dir).to receive(:new).and_return []

      subject.perform '/path/to/scan'
      expect(subject.logger.context).to eq 'job:scan'
    end

    it 'calls #process_file for all files in path, except dot files' do
      files = %w[. .. file1 file2]
      processed = []

      allow_any_instance_of(EBL::Logger).to receive(:log).and_return true
      allow(Dir).to receive(:new).and_return files
      allow(subject).to receive(:process_file) do |p1|
        processed.push(p1)
      end

      subject.perform '/path/to/scan'
      expect(processed).to eq %w[file1 file2]
    end
  end

  describe '#initialise_book' do
    context 'when the type is :epub' do
      it 'returns a book via Book.from_epub' do
        dbl = double('Book')
        allow(EBL::Models::Book).to receive(:from_epub).and_return dbl
        expect(subject.initialise_book('path', :epub)).to eq dbl
      end
    end

    context 'when the type is :pdf' do
      it 'returns a book via Book.from_pdf' do
        dbl = double('Book')
        allow(EBL::Models::Book).to receive(:from_pdf).and_return dbl
        expect(subject.initialise_book('path', :pdf)).to eq dbl
      end
    end

    context 'when the type is not :pdf or :epub' do
      it 'returns nil' do
        expect(subject.initialise_book('path', :invalid)).to be_nil
      end
    end
  end
end
