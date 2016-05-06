module Helpstation
  module Fetchers
    NotFoundError = Class.new(StandardError)

    class ByKeyFetcher < Processor
      def self.build(input_key, output_key, &block)
        Class.new(self) do
          define_method :input_key do
            input_key
          end
          define_method :output_key do
            output_key
          end
          define_method :fetch do |input_value|
            block.call input_value, env
          end
        end
      end

      def call
        if input_value = input[input_key]
          success(input.merge(output_key => fetch(input_value)))
        else
          error("#{input_key} must be present")
        end
      rescue NotFoundError
        error("#{Inflecto.humanize(output_key)} ##{input_value} not found")
      end
    end

    class ActiveRecordFetcher < ByKeyFetcher
      def call
        super
      rescue ActiveRecord::RecordNotFound
        error("#{Inflecto.humanize(output_key)} ##{input[input_key]} not found")
      end
    end
  end
end
