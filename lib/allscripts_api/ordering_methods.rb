# frozen_string_literal: true

module AllscriptsApi
  # A collection convenience methods for ordering that map
  # to Allscripts magic actions. Some of these methods
  # wrap multiple actions. These methods are included
  # in `AllscriptsApi::Client` and can be accessed from
  # instances of that class.
  module OrderingMethods
    # a wrapper around SaveOrder, which save and order of the
    # sepcified category, among: AdministeredMedication,
    # Immunization, InstructionOrder, ProcedureOrder,
    # Referral, SuppliesOrder.
    #
    # xml can be constructed with `Allscripts::Order.build_xml`
    #
    # @param patient_id [String]
    # @param xml [String] xml containing saveorderxml fields and values
    # @param order_category [String] one of AdministeredMedication,
    # Immunization, InstructionOrder, ProcedureOrder,
    # Referral, SuppliesOrder.
    # @param dictionary_id [String] id of the dictionary from SearchOrder
    # @param problem_id [String|Nil] problem to associate with the order,
    # may be passed in as part of the xml
    # @param trans_id [String|Nil] the original OrderID,
    # necessary when updating a past order
    # @return ...
    def save_order(patient_id, xml, order_category, dictionary_id,
                   problem_id = nil, trans_id = nil)
      params = MagicParams.format(
        user_id: @allscripts_username,
        patient_id: patient_id,
        parameter1: xml,
        parameter2: order_category,
        parameter3: dictionary_id,
        parameter4: problem_id,
        parameter5: trans_id
      )
      magic("SaveOrder", magic_params: params)
    end
  end
end
