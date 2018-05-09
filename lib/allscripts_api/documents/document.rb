# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # A value object wrapped around a {Nokogiri::XML::Builder}
    # DSL that builds properly formatted XML for
    # {AllscriptsApi::OrderingMethods.save_document_image}
    class Document
      REQUIRED_PARAMS =
        %i[bytes_read b_done_upload document_var first_name last_name].freeze
      # Builder method for returning XML needed to save document images
      #
      # @param file_name [String] name of the file you wish to save
      # @param command [String] i for insert, e for delete (entered in error),
      # u for update
      # @param params [Hash] any other params you may wish to pass to the api
      # @return [String] xml formatted for
      # {AllscriptsApi::OrderingMethods#save_document_image}
      # bytes_read = 0, bDoneUpload = false, documentVar = ""
      def self.build_xml(file_name, command = "i", params)
        Utilities::Validator.validate_params(REQUIRED_PARAMS, params)
        builder = Nokogiri::XML::Builder.new
        builder.document do
          # i for insert, e for delete (entered in error), u for update
          builder.item("name" => "documentCommand", "value" => command)
          # document_type_de.entrycode value GetDictionary
          builder.item("name" => "documentType", "value" => "sEKG")
          # file offset of the current chunk to upload
          builder.item("name" => "offset", "value" => "0")
          # how many bytes in current chunk
          builder.item("name" => "bytesRead", "value" => params[:bytes_read])
          # false until the last chunk, then call SaveDocumentImage
          # once more with true
          builder.item("name" => "bDoneUpload",
                       "value" => params[:b_done_upload])
          # empty for first chunk, which will then return the GUID to use for
          # subsequent calls
          builder.item("name" => "documentVar",
                       "value" => params[:document_var])
          # documentid only applies to updates
          builder.item("name" => "documentID", "value" => "0")
          # actual file name
          builder.item("name" => "vendorFileName", "value" => file_name)
          # Valid encounterID from GetEncounter Set to "0" to create encounter
          # based on ahsEncounterDDTM value
          builder.item("name" => "ahsEncounterDTTM", 
                       "value" => "2013-12-30 11:32:24")
          builder.item("name" => "ahsEncounterID", "value" => "0")
          # EntryCode value from GetProvider
          builder.item("name" => "ownerCode", "value" => "TW0001")
          # required to ensure the proper patient is identified
          builder.item("name" => "organizationName",
                       "value" => "New World Health")
          # required for event table entries, audit
          builder.item("name" => "patientFirstName", "value" => params[:first_name])
          builder.item("name" => "patientLastName", "value" => params[:last_name])
          # Indicate how to display in TouchWorks EHR UI:
          # 1=No Rotation, 2=Rot 90 deg, 3=Rot 180 Deg, 4=Rot 270 Deg
          builder.item("name" => "Orientation", "value" => "1")
          builder.item("name" => "auditCCDASummary", "value" => "N")
        end
        # This is a hack to get around Nokogiri choking on
        # {Nokogiri::XML::Builder.doc}
        builder.to_xml.gsub("document>", "doc>")
      end
    end
  end
end
