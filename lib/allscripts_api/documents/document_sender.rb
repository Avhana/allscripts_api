# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # Wraps {AllscriptsApi::Documents::Document.build_xml} and
    # {AllscriptsApi::Documents::DocumentMethods#save_document_image}
    # to handle the 2 step document image saving process
    # The DocumentSender is set up to send the document as one big chunk
    class DocumentSender
      # rubocop:disable LineLength
      # The new method sets up eerything needed to run {#send_document}
      #
      # @example Usage Example
      #   document_params =
      #     {
      #       bytes_read: pdf.bytes.length,
      #       b_done_upload: false,
      #       document_var: "",
      #       patient_id: 19,
      #       owner_code: "TW0001",
      #       first_name: "Allison",
      #       last_name: "Allscripts",
      #       document_type: "sEKG",
      #       organization_name: "New World Health"
      #     }
      #   ds = AllscriptsApi::Documents::DocumentSender.new(client, pdf, "test.pdf", document_params)
      #   ds.send_document
      #
      # @param client [AllscriptsApi::Client] pass in an authorized client
      # @param document [String] the string contents of the pdf to be saved
      # @param file_name [String] the name of the file to be saved, usually ending in .pdf
      # @param params [Hash] a hash of params for use in saving a document
      # @see {AllscriptsApi::Documents::DocumentSender} for details
      # @return [AllscriptsApi::Documents::DocumentSender]
      # rubocop:enable LineLength
      def initialize(client, document, file_name, params)
        @params = params
        @patient_id = @params[:patient_id]
        raise MissingRequiredParamsError, "patient_id required" unless @patient_id
        @client = client
        @document = Base64.encode64(document)
        @file_name = file_name
      end

      # Sends the document in 2 steps, first the doc itself, then
      # a confirmation that it is done and ready to be saved.
      # @return [Hash, MagicError] a confirmation or error
      def send_document
        @params[:b_done_upload] = "false"
        doc_builder_params = [@file_name, "i", @params]
        results =
          @client.save_document_image(@patient_id,
                                      doc_builder_params, nil, @document)
        @params[:b_done_upload] = "true"
        @params[:document_var] = results[0]["documentVar"]
        second_step_xml =
          Documents::Document.build_xml(@file_name, "i", @params)
        @client.save_document_image(@patient_id,
                                    second_step_xml, nil, @document)
      end
    end
  end
end
