require 'spec_helper'

describe Helpstation::Fetchers::ActiveRecordFetcher do
  subject(:response) { processor.call(Substation::Request.new('my_request', env, input)) }

  let(:env) { { mock_service: :mock_value } }
  let(:input_key) { :my_input }
  let(:output_key) { :my_output }

  context 'when record is present' do
    let(:processor) {
      described_class.build(input_key, output_key) do |key, env|
        record
      end
    }
    let(:record) { double }
    let(:input) { { my_input: input_key } }

    it 'returns the record' do
      expect(response).to be_a(Substation::Response::Success)
      expect(response.output).to eq(
        my_input: input[:my_input],
        my_output: record
      )
    end
  end

  context 'when record is not found' do
    # Helpstation does not have AR depndencies, so we mock them out
    module ActiveRecord
    end

    class ActiveRecord::RecordNotFound < Exception
    end

    let(:processor) {
      described_class.build(input_key, output_key) do |key, env|
        raise ActiveRecord::RecordNotFound.new "No record"
      end
    }
    let(:input) { { my_input: 'input_key' } }

    it 'returns error response' do
      expect(response).to be_a(Substation::Response::Failure)
      expect(response.output).to eq(
        success: false,
        error: "My output #input_key not found"
      )
    end
  end
end
