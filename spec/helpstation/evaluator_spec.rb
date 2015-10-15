require 'spec_helper'

describe Helpstation::Evaluator do
  subject { target_class.call(request) }

  let(:request) { Substation::Request.new(:name, {}, {}) }

  describe '#error' do
    let(:target_class) do
      Class.new(described_class) do
        def call
          error('ERROR', message: 'a message')
        end
      end
    end

    it 'returns an error response' do
      should be_a(Substation::Response::Failure)
    end

    it 'returns status' do
      expect(subject.output).to eq(
        success: false, error: 'ERROR', message: 'a message'
      )
    end
  end
end
