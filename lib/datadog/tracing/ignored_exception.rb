# frozen_string_literal: true

module Datadog
  module Tracing
    # TODO
    module IgnoredException
      def self.constant_resolve(constant_name)
        constant_name = constant_name.to_s unless constant_name.is_a?(String)
        Object.const_get(constant_name)
      rescue NameError
        nil
      end

      def self.constants_resolve(constant_names)
        constant_names.map { |constant_name| constant_resolve(constant_name) }.compact
      end

      def self.ignored?(exception)
        Datadog.configuration.tracing.ignored_exceptions.include?(exception.class.name)
      end
    end
  end
end
