# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # Wraps {AllscriptsApi::Documents::Document.build_xml} and
    # {AllscriptsApi::Documents::DocumentMethods#save_document_image}
    # to handle the 2 step document image saving process
    #
    # @param client [AllscriptsApi::Client] pass in an authorized client
    # @param document [String] the string contents of the pdf to be saved
    # @param file_name [String] the name of the file to
    # be saved, usually ending in `.pdf`
    # @param params [Hash] a hash of params for use in saving a document
    # params may look like the following:
    # {
    #   bytes_read: 0,
    #   b_done_upload: false,
    #   document_var: ""
    # }
    # @return [Hash, MagicError] a confirmation or error
    class DocumentSender
      def initialize(client, document, file_name, params)
        @client = client
        @document = Base64.encode64(document)
        @file_name = file_name
        @params = params
        @patient_id = @params[:patient_id]
      end

      def send_document
        @params[:b_done_upload] = "false"
        first_step_xml =
          Documents::Document.build_xml(@file_name, "i", @params)
        results =
          @client.save_document_image(@patient_id,
                                      first_step_xml, @document)
        @params[:b_done_upload] = "true"
        @params[document_var] = results[0]["documentVar"]
        second_step_xml =
          Documents::Document.build_xml(@file_name, "i", @params)
        @client.save_document_image(@patient_id,
                                    second_step_xml, @document)
      end
    end
  end
end
