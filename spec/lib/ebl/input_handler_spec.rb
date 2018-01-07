require_relative '../../spec_helper'
require 'lib/ebl/input_handler'

describe EBL::InputHandler do
  let(:subject) { described_class.new(logger_dbl) }
  let(:logger_dbl) { double('EBL::Logger') }
  let(:user_input) { 'test' }
  let(:directory_res) { true }

  before :each do
    allow(subject).to receive(:puts) { |m| m }
    allow(logger_dbl).to receive(:log).and_return true
    allow(Readline).to receive(:readline).and_return user_input
    allow(subject).to receive(:gets).and_return user_input
    allow(STDIN).to receive(:noecho).and_return user_input
    allow(subject).to receive(:print).and_return true
    allow(subject).to receive(:puts).and_return true
    allow(File).to receive(:directory?).and_return directory_res
  end

  describe '#new' do
    it 'initialises #logger with the logger specified' do
      expect(subject.logger).to eq logger_dbl
    end
  end

  describe '#get_alphanumeric_value' do
    it 'prompts the user for a value' do
      prompted = false
      allow(Readline).to receive(:readline) do
        prompted = true
      end

      subject.get_alphanumeric_value('', 0, 1)
      expect(prompted).to be true
    end

    context 'when the value is not between min and max alphanumeric chars' do
      it 'logs an error' do
        logged = false
        allow(logger_dbl).to receive(:log) do |p1, p2|
          logged = (p2 == :red) && !/must contain/.match(p1).nil?
        end

        subject.get_alphanumeric_value('', 2, 3)
        expect(logged).to be true
      end

      it 'returns nil' do
        expect(subject.get_alphanumeric_value('', 10, 15)).to be_nil
      end
    end

    context 'when a valid value is specified' do
      it 'returns the value entered' do
        expect(subject.get_alphanumeric_value('', 1, 10)).to eq 'test'
      end
    end
  end

  describe '#gets_no_echo' do
    it 'disables STDIN echo' do
      disabled = false

      allow(STDIN).to receive(:noecho) do
        disabled = true
        user_input
      end

      subject.gets_no_echo ''
      expect(disabled).to be true
    end

    it 'returns the data entered' do
      expect(subject.gets_no_echo('')).to eq user_input
    end
  end

  describe '#get_password' do
    context 'when the passsword entered is less than min chars' do
      it 'returns nil' do
        expect(subject.get_password(20)).to be_nil
      end
    end

    context 'when the confirmation password does not match the first input' do
      it 'returns nil' do
        allow(subject).to receive(:gets_no_echo).and_return 'test', 'test2'
        expect(subject.get_password(1)).to be_nil
      end
    end

    context 'when the two passwords match and are the correct length' do
      it 'returns the password entered' do
        expect(subject.get_password(1)).to eq 'test'
      end
    end
  end

  describe '#get_path' do
    context 'when the specified directory exists' do
      let(:directory_res) { true }
      let(:user_input) { '/test' }

      it 'returns the path' do
        expect(subject.get_path('test')).to eq user_input
      end

      context 'when a new line appears at the end of the path' do
        let(:user_input) { "/path/with/whitespace\r\n" }
        it 'chomps the new line from the end' do
          expect(subject.get_path('test')).to eq '/path/with/whitespace'
        end
      end
    end

    context 'when the specified directory does not exist' do
      let(:directory_res) { false }
      let(:user_input) { '/test' }

      it 'returns nil' do
        expect(subject.get_path('test')).to be_nil
      end
    end
  end
end
