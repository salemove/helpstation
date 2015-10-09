require 'spec_helper'

describe Helpstation::Processors::ParallelProcessor do
  subject { processor.call(request) }

  let(:processor) { described_class[processor1, processor2] }

  let(:processor1) do
    Proc.new do |request|
      sleep 0.1
      request.success(request.input.merge(processor1: 'obj'))
    end
  end

  let(:request) { Substation::Request.new(:name, {}, input) }
  let(:input) { {initial: 'obj'} }

  context 'when successful' do
    let(:processor2) do
      Proc.new do |request|
        sleep 0.1
        request.success(request.input.merge(processor2: 'obj'))
      end
    end

    it 'runs in parallel' do
      expect {
        subject
      }.to change(Time, :now).by_at_most(0.12)
    end

    it 'merges the results' do
      should be_a(Substation::Response::Success)
      expect(subject.output).to eq(
        initial: 'obj',
        processor1: 'obj',
        processor2: 'obj'
      )
    end
  end

  context 'when one processor fails' do
    let(:processor2) do
      Proc.new do |request|
        sleep 0.1
        request.error(no: 'way')
      end
    end

    it 'returns the error response' do
      should be_a(Substation::Response::Failure)
      expect(subject.output).to eq(no: 'way')
    end
  end

  context 'when one process has an exception' do
    let(:processor2) do
      Proc.new do |request|
        sleep 0.1
        this_throws_an_exception
        request.success(processor2: 'obj')
      end
    end

    it 'throws the exception' do
      expect {
        subject
      }.to raise_error(NameError)
    end
  end
end
