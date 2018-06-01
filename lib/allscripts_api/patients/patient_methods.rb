# frozen_string_literal: true

module AllscriptsApi
  module Patients
    # A collection convenience methods for ordering that map
    # to Allscripts magic actions related to patients.
    # These methods are included in {AllscriptsApi::Client} 
    # and can be accessed from instances of that class.
    module PatientMethods
      # gets data elements of a patient's history
      #
      # @param patient_id [String] patient id
      # @param section [String] section
      #   if no section is specified than all sections wt data are returned
      #   list multiple sections by using a pipe-delimited list ex. "Vitals|Alerts"
      # @param encounter_id [String] internal identifier for the encounter
      #   the EncounterID can be acquired with GetEncounterList
      # @param verbose [String] XMLDetail
      #   verbose column will be Y or blank, when Y is provided there will be a
      #   piece of XML data that is specific to that element of the patient's chart
      # @return [String, AllscriptsApi::MagicError] clinical summary for patient
      def get_clinical_summary(patient_id,
                               section = nil,
                               encounter_id = nil,
                               verbose = nil)
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: section,
            parameter2: encounter_id,
            parameter3: verbose
          )
        results = magic("GetClinicalSummary", magic_params: params)
        results["getclinicalsummaryinfo"]
      end

      # Returns a list of Patient IDs whose information has been
      #   modified since a timestamp
      #
      # @param patient_id [String] patient id
      # @param since [DateTime]  DateTime indicating how far back to
      #   query for changed patients.
      # @param clinical_data_only [String] Indicates whether to
      #   look at only changes in clinical data. Y or N
      # @param verbose [String] Do you want to see the specific areas that have changed
      # @param quick_scan [String] Set to Y to enable new change patient scanning functionality.
      # @return [String, AllscriptsApi::MagicError] changed data for patient
      def get_changed_patients(patient_id, since,
                               clinical_data_only = "Y",
                               verbose = "Y", quick_scan = "N")
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: since.strftime("%m/%d/%Y"),
            parameter2: clinical_data_only,
            parameter3: verbose,
            parameter4: quick_scan
          )

        results = magic("GetChangedPatients", magic_params: params)
        results["getchangedpatientsinfo"]
      end
    end
  end
end
