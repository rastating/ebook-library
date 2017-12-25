require_relative '../../spec_helper'

describe EBL::Helpers::LoggingHelper do
  let(:subject) do
    Class.new do
      include EBL::Helpers::LoggingHelper
    end.new
  end

  describe '#setup_logger' do
    it 'creates a new logger with the specified context' do
      subject.setup_logger 'test'
      expect(subject.logger).to be_a EBL::Logger
      expect(subject.logger.context).to eq 'test'
    end
  end

  describe '#log_error' do
    it 'calls #log on #logger using :red as the colour' do
      allow_any_instance_of(EBL::Logger).to receive(:log) do |_this, p1, p2|
        expect(p1).to eq 'test'
        expect(p2).to eq :red
      end

      subject.setup_logger 'test'
      subject.log_error 'test'
    end
  end

  describe '#log_green' do
    it 'calls #log on #logger using :green as the colour' do
      allow_any_instance_of(EBL::Logger).to receive(:log) do |_this, p1, p2|
        expect(p1).to eq 'test'
        expect(p2).to eq :green
      end

      subject.setup_logger 'test'
      subject.log_green 'test'
    end
  end
end
