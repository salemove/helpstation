module Helpstation
  class Observer
    include AbstractType

    # Perform the observer
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

    def success?
      @response.success?
    end
  end

  class SuccessObserver < Observer
    # Perform the observer when the response is successful
    #
    # @param [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(response)
      super if response.success?
    end
  end

  class ErrorObserver < Observer
    # Perform the observer when the response is not successful
    #
    # @param [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(response)
      super if !response.success?
    end
  end
end
