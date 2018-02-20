# frozen_string_literal: true

module AllscriptsApi
  # A simple formatter for Magic Action's numbered perameters
  class NumberedParams
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
