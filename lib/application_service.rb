require 'substation'

require_relative 'application_service/version'
require_relative 'application_service/evaluator'
require_relative 'application_service/processor'
require_relative 'application_service/action'
require_relative 'application_service/observer'
require_relative 'application_service/legacy_process'

module ApplicationService
  def self.build_substation(env)
    Substation::Environment.build(env) do
      register :process, Substation::Processor::Evaluator::Request
      register :call, Substation::Processor::Evaluator::Pivot
    end
  end
end
