# frozen_string_literal: true

module AllscriptsApi
  module Demographics
    # A collection convenience methods for ordering that map
    # to Allscripts magic actions related to demographics calls.
    # These methods are included in {AllscriptsApi::Client}
    # and can be accessed from instances of that class.
    module DemographicsMethods
      # a wrapper around SearchPatients
      #
      # @param search_string [String] may be a name, birthdate
      #   partial address, or other PHI
      # @return [Array<Hash>, Array, MagicError] a list of found patients,
      #   an empty array, or an error
      def search_patients(search_string)
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            parameter1: search_string
          )
        results = magic("SearchPatients", magic_params: params)
        results["searchpatientsinfo"]
      end

      # gets patient's demographic info, insurance, guarantor, and PCP info
      #
      # @param patient_id [String] patient id
      # @param patient_number [String] PM patient number
      # @return [String, AllscriptsApi::MagicError] patient demographics
      def get_patient(patient_id, patient_number = nil)
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: patient_number
          )
        results = magic("GetPatient", magic_params: params)
        results["getpatientinfo"]
      end

      # gets patient's demographic info, insurance, guarantor, and PCP info
      # Note that this method is litely to return blank data sets
      # for invalid IDs rather than raising an error
      #
      # @param patient_id [String] patient id
      # @param mrn [String|nil] medical record number, if patient id is unknown
      # @param order_id [String|nil] optionally used to get info for a secific
      # patient order
      # @return [String, AllscriptsApi::MagicError] patient demographics
      def get_patient_full(patient_id, mrn = nil, order_id = nil)
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: mrn,
            parameter2: order_id
          )
        results = magic("GetPatientFull", magic_params: params)
        results["getpatientfullinfo"]
      end
    end
  end
end
