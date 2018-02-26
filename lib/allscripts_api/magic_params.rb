# frozen_string_literal: true

module AllscriptsApi
  # A simple formatter for Magic Action's numbered perameters
  class MagicParams
    # A method for formatting data for the body of {AllscriptsApi::Client#magic}
    # calls. Magic Actions require all arguments to be present in the HTTP call
    # and in the correct order.
    #
    # @param user_id [String] id or user name of the App/User making the call
    # @param patient_id [String, Nil] the optional id of a patient 
    # related to the Magic call
    # @param parameter1 [String, Nil] the optional 1st argument of the Magic call
    # @param parameter2 [String, Nil] the optional 2nd argument of the Magic call
    # @param parameter3 [String, Nil] the optional 3rd argument of the Magic call
    # @param parameter4 [String, Nil] the optional 4th argument of the Magic call
    # @param parameter5 [String, Nil] the optional 5th argument of the Magic call
    # @param parameter6 [String, Nil] the optional 6th argument of the Magic call
    # @param data [Hash, Nil] the optional data argument of the Magic call
    #
    # @return [Hash] the method returns a formatted hash containing the
    # passed parameters and empty values for unused params
    # @example formatting params for SearchPatients as seen in {NamedMagicMethods#search_patients}
    #   MagicParams.format(user_id: "YOUR_APP_USERNAME, parameter1: "Smith")
    #   => {AppUserID: "YOUR_APP_USERNAME",
    #     PatientID: "",
    #     Parameter1: "Smith",
    #     Parameter2: "",
    #     Parameter3: "",
    #     Parameter4: "",
    #     Parameter5: "",
    #     Parameter6: "",
    #     Data: {}}
    def self.format(user_id: "", patient_id: "", parameter1: "", parameter2: "", parameter3: "", parameter4: "", parameter5: "", parameter6: "", data: {})
      {
        AppUserID: user_id,
        PatientID: patient_id,
        Parameter1: parameter1,
        Parameter2: parameter2,
        Parameter3: parameter3,
        Parameter4: parameter4,
        Parameter5: parameter5,
        Parameter6: parameter6,
        Data: data
      }
    end
  end
end
