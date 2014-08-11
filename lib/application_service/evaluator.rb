module ApplicationService
  class Evaluator
    include AbstractType

    # Perform the usecase
    #
    # @param [Substation::Request] request
    #   the request passed to the registered action
    #
    # @return [Substation::Response]
    #   the response returned when calling the action
    #
    # @api private
    def self.call(request)
      new(request).call
    end

    def initialize(request)
      @request = request
      @env     = request.env
      @input   = request.input
    end

    abstract_method :call

    private

    attr_reader :request
    attr_reader :env
    attr_reader :input

    def error(data)
      @request.error(success: false, error: data)
    end
  end
end
