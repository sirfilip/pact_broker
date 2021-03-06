require 'pact_broker/api/resources/base_resource'
require 'pact_broker/api/decorators/matrix_decorator'

module PactBroker
  module Api
    module Resources
      class MatrixForConsumerAndProvider < BaseResource

        def initialize
          super
          _, @options = PactBroker::Matrix::ParseQuery.call(request.uri.query)
        end

        def content_types_provided
          [["application/hal+json", :to_json]]
        end

        def allowed_methods
          ["GET", "OPTIONS"]
        end

        def resource_exists?
          consumer && provider
        end

        def to_json
          PactBroker::Api::Decorators::MatrixDecorator.new(results).to_json(user_options: { base_url: base_url })
        end

        private

        attr_reader :options

        def results
          @results ||= matrix_service.find_for_consumer_and_provider(identifier_from_path, options)
        end
      end
    end
  end
end
