# frozen_string_literal: true
module Wazuh
  module Sawyer
    module Request
      def get(path, options = {})
        request(:get, path, options)
      end

      def post(path, options = {})
        request(:post, path, options)
      end

      def put(path, options = {})
        request(:put, path, options)
      end

      def delete(path, options = {})
        request(:delete, path, options)
      end

      private

      def request(method, path, options)
        response = case method
        when :get, :delete
          connection.call(method, URI::Parser.new.escape(path), nil, {query: options})
        when :post, :put
          data = options unless options.empty?
          connection.call(method, URI::Parser.new.escape(path), data)
        end

        return response.data.data if response.status == 200 || response.data.error == 0
        
        error_message = response.data.message
        raise Wazuh::Api::Errors::WazuhError.new(error_message, response)
      end
    end
  end
end
