# frozen_string_literal: true

module AllscriptsApi
  module Utilities
    # Simple module that provides `validate_params`
    # which  raises {MissingRequiredParamsError} if
    # if required params are missing.
    module Validator
      # Raises and error if required params are missing
      # @param required_params [Array<Symbol>]
      # @param params [Hash] params to be validated
      def self.validate_params(required_params, params)
        # TODO: describe why this works
        missing_keys = required_params - params.keys
        unless missing_keys.empty?
          raise MissingRequiredParamsError,
                "The key(s) #{missing_keys} is/are required for this method."
        end
      end
    end
  end
end
