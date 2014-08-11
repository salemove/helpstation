module ApplicationService
  class Processor < Evaluator
    def success(data)
      @request.success(data)
    end
  end
end
