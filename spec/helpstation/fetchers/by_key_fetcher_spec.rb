require 'spec_helper'

describe Helpstation::Fetchers::ByKeyFetcher do
  subject { processor.call request }

  let(:processor) {
    described_class.build(input_key, output_key) do |key, env|
      "#{key} and #{env}"
    end
  }

  let(:env) { { mock_service: :mock_value } }

  let(:input_key) { :my_input }
  let(:output_key) { :my_output }
  let(:output) { "putting out" }

  let(:request)   { Substation::Request.new('my_request', env, input) }

  context 'when input_key is present' do
    let(:input) { { my_input: 'input_key' } }

    it 'returns correct output' do
      expect(subject).to be_a(Substation::Response::Success)
      expect(subject.output).to eq(
        my_input: input[:my_input],
        my_output: "input_key and {:mock_service=>:mock_value}"
      )
    end
  end

  context 'when input_key is not present' do
    let(:input) { {} }

    it 'returns error with appropriate message' do
      expect(subject).to be_a(Substation::Response::Failure)
      expect(subject.output).to eq(
        success: false,
        error: "#{input_key} must be present"
      )
    end
  end
end
