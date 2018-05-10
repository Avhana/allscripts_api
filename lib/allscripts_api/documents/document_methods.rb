# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # A collection of named convenience methods that map
    # to Allscripts magic actions related to documents.
    # These methods are included in {AllscriptsApi::Client}
    # and can be accessed from instances of that class.
    module DocumentMethods
      # rubocop:disable LineLength
      # a wrapper around SaveDocumentImage, which saves pdfs to Allscripts
      #
      # @param patient_id [String] patient id
      # @param document_params [String] XML produced by {AllscriptsApi::Documents::Document.build_xml}
      # @param document_buffer [String] a byte array of document data for the current chunk.
      # @param base_64_data [String] Alternative to using the Data parameter. If Data parameter is empty/null, Unity will check for presence of content in Base64Data. Note: In the Parameter1 XML, bytesRead is still the number of document bytes and not the base-64 string length.
      # @return [Hash, MagicError] a confirmation or error
      # rubocop:Enable LineLength
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
