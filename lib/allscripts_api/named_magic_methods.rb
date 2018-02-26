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
