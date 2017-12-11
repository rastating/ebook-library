require_relative '../../spec_helper'

describe EBL::Logger do
  let(:subject) { described_class.new }

  before :each do
    allow(subject).to receive(:puts) { |m| m }
  end

  describe '#log' do
    context 'when passed an invalid colour code' do
      it 'raises an error' do
        msg = 'Unknown colour code: invalid'
        expect { subject.log('', :invalid) }.to raise_error(msg)
      end
    end

    context 'when the context is not empty' do
      it 'outputs the context in the specified colour' do
        output = "#{'[context]'.yellow} msg"
        subject.context = 'context'
        expect(subject.log('msg', :yellow)).to eq output
      end
    end

    context 'when the context is empty' do
      it 'omits the context parentheses from the output' do
        expect(subject.log('msg')).to_not match(/\[\]/)
      end

      it 'outputs the message in the specified colour' do
        expect(subject.log('msg', :yellow)).to eq 'msg'.yellow
      end
    end
  end
end
