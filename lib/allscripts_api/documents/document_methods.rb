# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # A collection of named convenience methods that map
    # to Allscripts magic actions related to documents.
    # These methods are included in {AllscriptsApi::Client}
    # and can be accessed from instances of that class.
    module DocumentMethods
      # a wrapper around SaveDocumentImage, which saves pdfs to Allscripts
      #
      # @param patient_id [String] patient id
      # @param document_params [String] XML produced by
      # {AllscriptsApi::Document.build_xml}
      # @return [Hash, MagicError] a confirmation or error
      def save_document_image(patient_id, document_params,
                              document_buffer = nil, base_64_data = nil)
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: document_params,
            parameter6: base_64_data,
            data: document_buffer
          )
        results = magic("SaveDocumentImage", magic_params: params)
        results["savedocumentimageinfo"]
      end
    end
  end
end
