require 'substation'
require 'inflecto'

require_relative 'helpstation/version'
require_relative 'helpstation/evaluator'
require_relative 'helpstation/processor'
require_relative 'helpstation/action'
require_relative 'helpstation/observer'
require_relative 'helpstation/renderer'
require_relative 'helpstation/legacy_process'

require_relative 'helpstation/fetchers'
require_relative 'helpstation/processors'

module Helpstation
  def self.build_substation(env)
    Substation::Environment.build(env) do
      register :process, Substation::Processor::Evaluator::Request
      register :call, Substation::Processor::Evaluator::Pivot
      register :render, Substation::Processor::Transformer::Outgoing
    end
  end
end
