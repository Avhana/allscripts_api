# frozen_string_literal: true

module AllscriptsApi
  module Orders
    # A collection convenience methods for ordering that map
    # to Allscripts magic actions. Some of these methods
    # wrap multiple actions. These methods are included
    # in {AllscriptsApi::Client} and can be accessed from
    # instances of that class.
    module OrderingMethods
      # a wrapper around SaveOrder, which save and order of the
      # sepcified category, among: AdministeredMedication,
      # Immunization, InstructionOrder, ProcedureOrder,
      # Referral, SuppliesOrder.
      #
      # xml can be constructed with {AllscriptsApi::Orders::Order.build_xml}
      #
      # @param patient_id [String]
      # @param xml [String] xml containing saveorderxml fields and values
      # @param order_category [String] one of AdministeredMedication,
      # Immunization, InstructionOrder, ProcedureOrder,
      # Referral, SuppliesOrder.
      # @param dictionary_id [String] id of the dictionary from SearchOrder TODO: look into how to doc this better
      # @param problem_id [String|Nil] problem to associate with the order,
      # may be passed in as part of the xml
      # @param trans_id [String|Nil] the original OrderID,
      # necessary when updating a past order
      # @return [Hash|MagicError] order confirmation or error
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

      # a wrapper around GetOrderWorkflow
      #
      # @param patient_id [String] patient id
      # @param xml_string [String] xml from build_xml_for_order_workflow method
      # @param order_trans_id [String] order_activity_header.ID when calling for an existing order
      # @param order_category [String] determines what order field data to send back.
      # @param problem_id [String] problem dictionary id
      # @param problem_trans_id [String] problem_header id
      # @return [Array<Hash>, Array, MagicError] a list of encounters
      def get_order_workflow(patient_id, xml_string,
                             order_trans_id = "0", order_category = "ProcedureOrder",
                             problem_id = "", problem_trans_id = "")
        params =
          MagicParams.format(
            user_id: @allscripts_username,
            patient_id: patient_id,
            parameter1: xml_string,
            parameter2: order_trans_id,
            parameter3: order_category,
            parameter4: problem_id,
            parameter5: problem_trans_id
          )
        results = magic("GetOrderWorkflow", magic_params: params)
        results["getorderworkflow"]
      end
    end
  end
end
