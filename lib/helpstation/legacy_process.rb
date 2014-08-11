module Helpstation
  class LegacyProcess
    def self.call(request)
      result = process(request.env, request.input)
      result[:success] ? request.success(result) : request.error(result)
    end
  end
end
