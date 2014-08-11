module ApplicationService
  class Action < Evaluator
    def success(data)
      @request.success({success: true}.merge(data))
    end
  end
end
