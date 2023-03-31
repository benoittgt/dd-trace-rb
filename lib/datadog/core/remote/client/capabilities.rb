# frozen_string_literal: true

require_relative '../../../appsec/remote'

module Datadog
  module Core
    module Remote
      class Client
        # Capbailities
        class Capabilities
          attr_reader :products, :capabilities, :receivers, :binary_capabilities

          def initialize(settings)
            @capabilities = []
            @products = []
            @receivers = []

            register(settings)

            @binary_capabilities = compute_capabilities
          end

          private

          def register(settings)
            if settings.appsec.enabled
              register_capabilities(Datadog::AppSec::Remote.capabilities)
              register_products(Datadog::AppSec::Remote.products)
              register_receivers(Datadog::AppSec::Remote.receivers)
            end
          end

          def register_capabilities(capabilities)
            @capabilities.concat(capabilities)
          end

          def register_receivers(receivers)
            @receivers.concat(receivers)
          end

          def register_products(products)
            @products.concat(products)
          end

          def compute_capabilities
            return '' if capabilities.empty?

            cap_to_hexs = capabilities.reduce(:|).to_s(16).tap { |s| s.size.odd? && s.prepend('0') }.scan(/\h\h/)
            binary = cap_to_hexs.each_with_object([]) { |hex, acc| acc << hex }.map { |e| e.to_i(16) }.pack('C*')

            Base64.encode64(binary).chomp
          end
        end
      end
    end
  end
end
