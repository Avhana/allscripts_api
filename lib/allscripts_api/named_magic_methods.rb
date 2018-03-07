# frozen_string_literal: true

module AllscriptsApi
  # A collection of named convenience methods that map
  # to Allscripts magic actions. These methods are included
  # in `AllscriptsApi::Client` and can be accessed from
  # instances of that class.
  module NamedMagicMethods
    # a wrapper around SearchPatients
    #
    # @param search_string [String] may be a name, birthdate
    # partial address, or other PHI
    # @return [Array<Hash>, Array, MagicError] a list of found patients,
    # an empty array, or an error
    def search_patients(search_string)
      params =
        MagicParams.format(
          user_id: @allscripts_username,
          parameter1: search_string
        )
      results = magic("SearchPatients", magic_params: params)
      results["searchpatientsinfo"]
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
    def get_ccda(patient_id,
                 encounter_id,
                 org_id = nil,
                 app_group = nil,
                 referral_text = nil,
                 site_id = nil,
                 document_type = "CCDACCD")
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

    # gets data elements of a patient's history
    #
    # @param patient_id [String] patient id
    # @param section [String] section
    # if no section is specified than all sections wt data are returned
    # list multiple sections by using a pipe-delimited list ex. "Vitals|Alerts"
    # @param encounter_id [String] internal identifier for the encounter
    # the EncounterID can be acquired with GetEncounterList
    # @param verbose [String] XMLDetail
    # verbose column will be Y or blank, when Y is provided there will be a
    # piece of XML data that is specific to that element of the patient's chart
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

    # gets patient's demographic info, insurance, guarantor, and PCP info
    #
    # @param patient_id [String] patient id
    # @param patient_Number [String] PM patient number
    # @return [String, AllscriptsApi::MagicError] patient demographics
    def get_patient(patient_id,
                    patient_number = nil)
      params =
        MagicParams.format(
          user_id: @allscripts_username,
          patient_id: patient_id,
          parameter1: patient_number
        )
      results = magic("GetPatient", magic_params: params)
      results["getpatientinfo"]
    end

    # a wrapper around GetPatientProblems
    #
    # @param patient_id [String] patient id
    # @param show_by_encounter [String] Y or N (defaults to `N`)
    # @param assessed [String]
    # @param encounter_id [String] id for a specific patient encounter
    # @param filter_on_id [String]
    # @param display_in_progress [String]
    # @return [Array<Hash>, Array, MagicError] a list of found problems,
    # an empty array, or an error
    def get_patient_problems(patient_id,
                             show_by_encounter = "N",
                             assessed = nil,
                             encounter_id = nil,
                             filter_on_id = nil,
                             display_in_progress = nil)
      params = MagicParams.format(
        user_id: @allscripts_username,
        patient_id: patient_id,
        parameter1: show_by_encounter,
        parameter2: assessed,
        parameter3: encounter_id,
        parameter4: filter_on_id,
        parameter5: display_in_progress
      )
      results = magic("GetPatientProblems", magic_params: params)
      results["getpatientproblemsinfo"]
    end
  end
end
