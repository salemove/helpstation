require 'spec_helper'

describe Helpstation::Processors::ConditionalProcessor do
  subject(:process) { processor.call(request) }
  
  let(:processor) { described_class[condition, success_chain, fallback_chain] }
  
  let(:input) { {} }
  let(:env) { {} }
  let(:request)  { Substation::Request.new(:request, env, input) }
  let(:condition) { double }
  let(:success_chain) { double }
  let(:fallback_chain) { double }

  context 'when condition is true' do
    let(:condition) { ->(_response) { true } }

    it 'calls success chain' do
      expect(success_chain).to receive(:call).with(request).and_return(request)
      process
    end
  end

  context 'when condition is false' do
    let(:condition) { ->(_response) { false } }
    
    it 'calls fallback chain' do
      expect(fallback_chain).to receive(:call).with(request).and_return(request)
      process
    end
  end
  
  context 'when underlying chain returns request' do
    let(:condition) { ->(_response) { true } }

    it 'wrap it in success response' do
      expect(success_chain).to receive(:call).with(request).and_return(request)
      expect(process).to eq(Substation::Response::Success.new(request, input))
    end
  end
  
  context 'when underlying chain returns failure' do
    let(:condition) { ->(_response) { true } }

    it 'returns failure response' do
      failure = Substation::Response::Failure.new(request, input)
      expect(success_chain).to receive(:call).with(request).and_return(failure)
      expect(process).to eq(failure)
    end
  end
end