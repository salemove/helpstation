module Helpstation
  class Renderer < Evaluator
    include AbstractType

    # Perform the renderer
    #
    # @param [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(response)
      new(response).call
    end

    def initialize(response)
      @response = response
      @env      = response.env
      @input    = response.input
      @output   = response.output
      @request  = response.request
    end

    abstract_method :call

    private

    attr_reader :env
    attr_reader :input
    attr_reader :output
  end
end
