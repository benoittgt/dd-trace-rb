require_relative '../analytics'

module Datadog
  module Tracing
    module Contrib
      module ActionPack
        # Common utilities for ActionPack
        module Utils
          def self.exception_is_error?(exception)
            !!defined?(::ActionDispatch::ExceptionWrapper) && !IgnoredExceptionHandler.ignored?(exception)
          end

          def self.set_analytics_sample_rate(span)
            if Contrib::Analytics.enabled?(datadog_configuration[:analytics_enabled])
              Contrib::Analytics.set_sample_rate(span, datadog_configuration[:analytics_sample_rate])
            end
          end

          class << self
            private

            def datadog_configuration
              Datadog.configuration.tracing[:action_pack]
            end
          end
        end
      end
    end
  end
end
