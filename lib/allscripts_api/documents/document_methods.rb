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
      def save_document_image(patient_id, doc_builder_params,
                              document_buffer = nil, base_64_data = nil)

        binding.pry

        chunk = 16384
        bDone = false;
        offset = 0;
        pdfByteLength = base_64_data.length
        document_var = nil

        while !bDone
           if ((pdfByteLength - offset) == 0)
              puts "pdfByteLength - offset == 0 so we won't do another iteration after this"
              bDone = true;
           elsif ((pdfByteLength - offset) < chunk)
              chunk = Math.abs(pdfByteLength - offset)
              bDone = true;
              puts "pdfByteLength - offset < chunk so we won't do another iteration after this"
              puts "last chunk: #{chunk}"
           end

           byteBuffer = base_64_data[offset..(offset + chunk)]
           puts "sending byte index: #{offset} to byte index: #{(offset + chunk)}"

           chunk_params = {offset: offset, chunk: chunk, document_var: document_var}
           first_step_xml =
             Documents::Document.build_xml(doc_builder_params[0], doc_builder_params[1], doc_builder_params[2], chunk_params)
           params =
             MagicParams.format(
               user_id: @allscripts_username,
               patient_id: patient_id,
               parameter1: first_step_xml,
               parameter6: byteBuffer,
               data: nil
             )
           results = magic("SaveDocumentImage", magic_params: params)
           results["savedocumentimageinfo"]

           offset += chunk
        end
      end

      # gets the CCDA documents for the specified patient and encounter
      #
      # @param patient_id [String] patient id
      # @param encounter_id [String] encounter id from which to generate the CCDA
      # @param org_id [String] specifies the organization, by default Unity
      # uses the organization for the specified user
      # @param app_group [String] defaults to "TouchWorks"
      # @param referral_text [String] contents of ReferralText are appended
      # @param site_id [String] site id
      # @param document_type [String] document type defaults to CCDACCD,
      # CCDACCD (Default) - Returns the Continuity of Care Document. This
      # is the default behavior if nothing is passed in.
      # CCDASOC - Returns the Summary of Care Document
      # CCDACS - Returns the Clinical Summary Document (Visit Summary).
      # @return [String, AllscriptsApi::MagicError] ccda for patient
      def get_ccda(patient_id, encounter_id, org_id = nil,
                   app_group = nil, referral_text = nil,
                   site_id = nil, document_type = "CCDACCD")
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: encounter_id,
            parameter2: org_id,
            parameter3: app_group,
            parameter4: referral_text,
            parameter5: site_id,
            parameter6: document_type
          )
        results = magic("GetCCDA", magic_params: params)
        results["getccdainfo"][0]["ccdaxml"]
      end
    end
  end
end
