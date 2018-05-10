# frozen_string_literal: true

module AllscriptsApi
  module Documents
    # A value object wrapped around a Nokogiri::XML::Builder
    # DSL that builds properly formatted XML for
    # {AllscriptsApi::OrderingMethods.save_document_image}
    # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Builder
    class Document
      # rubocop:disable LineLength
      # required parameters for building the XML, omitting any raises {MissingRequiredParamsError}
      REQUIRED_PARAMS =
        %i[bytes_read document_type first_name last_name
           organization_name owner_code].freeze
      # Builder method for returning XML needed to save document images
      #
      # @param file_name [String] name of the file you wish to save
      # @param command [String] i for insert, e for delete (entered in error), u for update
      # @param params [Hash] any other params you may wish to pass to the api
      # params may look like the following, all of which are required:
      # @option params [String] :bytes_read number of bytes in the chunk (use 0 for 1 big chunk)
      # @option params [String] :b_done_upload should be passed in as false,
      # @option params [String] :document_var "",
      # @option params [String] :patient_id 19,
      # @option params [String] :owner_code "TW0001",
      # @option params [String] :first_name "Allison",
      # @option params [String] :last_name "Allscripts",
      # @option params [String] :document_type document_type_de entrycode from value GetDictionary, for example, "sEKG"
      # @option params [String] :organization_name  the org's name, e.g. "New World Health"
      # @option params [String] :encounter_id  defaults to 0 to open a new encounter
      # @option params [String] :orientation  defaults to 1. 1=No Rotation, 2=Rot 90 deg, 3=Rot 180 Deg, 4=Rot 270 Deg
      # @see The '.pryrc' file for an example params hash
      # @return [String] xml formatted for {AllscriptsApi::OrderingMethods#save_document_image}
      # on required and optional params
      # rubocop:enable LineLength
      def self.build_xml(file_name, command = "i", params)
        Utilities::Validator.validate_params(REQUIRED_PARAMS, params)
        encounter_date_time = DateTime.now.strftime("%Y-%m-%d %H:%m:%S")
        builder = Nokogiri::XML::Builder.new
        builder.document do
          # i for insert, e for delete (entered in error), u for update
          builder.item("name" => "documentCommand",
                       "value" => command)
          # document_type_de.entrycode value GetDictionary
          builder.item("name" => "documentType",
                       "value" => params[:document_type])
          # file offset of the current chunk to upload
          # not yet supported by allscripts_api gem
          builder.item("name" => "offset",
                       "value" => "0")
          # how many bytes in current chunk
          builder.item("name" => "bytesRead", "value" => params[:bytes_read])
          # false until the last chunk, then call SaveDocumentImage
          # once more with true
          builder.item("name" => "bDoneUpload",
                       "value" => params[:b_done_upload] || "false")
          # empty for first chunk, which will then return the GUID to use for
          # subsequent calls
          builder.item("name" => "documentVar",
                       "value" => params[:document_var] || "")
          # documentid only applies to updates
          # not yet supported by allscripts_api gem
          builder.item("name" => "documentID",
                       "value" => "0")
          # actual file name
          builder.item("name" => "vendorFileName", "value" => file_name)
          # Valid encounterID from GetEncounter Set to "0" to create encounter
          # based on ahsEncounterDDTM value
          builder.item("name" => "ahsEncounterDTTM",
                       "value" => params[:encounter_time] ||
                                  encounter_date_time)
          builder.item("name" => "ahsEncounterID",
                       "value" => params[:encounter_id] || "0")
          # EntryCode value from GetProvider
          builder.item("name" => "ownerCode", "value" => params[:owner_code])
          # required to ensure the proper patient is identified
          builder.item("name" => "organizationName",
                       "value" => params[:organization_name])
          # required for event table entries, audit
          builder.item("name" => "patientFirstName",
                       "value" => params[:first_name])
          builder.item("name" => "patientLastName",
                       "value" => params[:last_name])
          # Indicate how to display in TouchWorks EHR UI:
          # 1=No Rotation, 2=Rot 90 deg, 3=Rot 180 Deg, 4=Rot 270 Deg
          builder.item("name" => "Orientation",
                       "value" => params[:orientation] || "1")
          builder.item("name" => "auditCCDASummary",
                       "value" => "N")
        end
        # This is a hack to get around Nokogiri choking on
        # {Nokogiri::XML::Builder.doc}
        builder.to_xml.gsub("document>", "doc>")
      end
    end
  end
end
