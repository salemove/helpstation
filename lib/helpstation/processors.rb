module Helpstation
  module Processors
    # Helps to run processors in parallel
    #
    # All output from the processors are merged and then returned. This means
    # that if two fetchers return results with the same key then one will
    # overwrite the other.
    #
    # @example
    #   process ParallelProcessor[
    #     OperatorFetcher,
    #     VisitorFetcher
    #   ], NOT_FOUND_ERROR
    #
    class ParallelProcessor < Processor
      def self.[](*processors)
        new(processors)
      end

      def initialize(processors)
        @processors = processors
      end

      def call(request)
        results = process_parallel(request)

        if first_failure = results.detect {|result| !result.success?}
          first_failure
        else
          request.success(results.reduce(request.input, &method(:compose)))
        end
      end

      private

      def process_parallel(request)
        @processors.map do |processor|
          Thread.new { processor.call(request) }
        end.map(&:join).map(&:value)
      end

      def compose(input, result)
        input.merge(result.output)
      end
    end

    # Helps to run one chain or another depending on a request
    #
    # @example
    #   success_chain = substation.chain do
    #     # success action
    #   end
    #
    #   fallback_chain = substation.chain do
    #     # fallback action
    #   end
    #
    #   process ConditionalProcessor[
    #     -> (request) { request.input.has_key?(:optional_key) },
    #     success_chain,
    #     fallback_chain
    #   ]
    #
    class ConditionalProcessor < Processor
      def self.[](condition, success_chain, fallback_chain)
        Proc.new do |request|
          result =
            if condition.call(request)
              success_chain.call(request)
            else
              fallback_chain.call(request)
            end

          if result.is_a?(Substation::Response)
            result
          else
            request.success(result.input)
          end
        end
      end
    end
  end
end
