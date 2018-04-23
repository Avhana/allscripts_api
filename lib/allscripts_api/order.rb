# frozen_string_literal: true

module AllscriptsApi
  # A value object wrapped around a `Nokogiri::XML::Builder` DSL that builds
  # properly formatted XML for `AllscriptsApi::OrderingMEthods.save_order`
  class Order
    # Builder method for returning XML
    #
    # @param site_id [String] the id for the Allscripts install site
    # @param emr_user_id [String] the provider's Allscripts id
    # @param order_date [DateTime] a date for the order (Typically today)
    # @param encounter_id [String|Nil] an encounter id, used when
    # ordering to current encounter
    # @return [String] xml formatted for
    # `AllscriptsApi::OrderingMEthods.save_order`
    def self.build_xml(site_id, emr_user_id, order_date, encounter_id = "")
      date = order_date.strftime("%d-%b-%Y")
      builder = Nokogiri::XML::Builder.new
      builder.saveorderxml do
        # a value of 'Y' makes the order visible on the order list
        builder.field("id" => "ordershowonorderlist", "value" => "Y")
        builder.field("id" => "orderlocation", "value" => site_id)
        builder.field("id" => "ordertobedone", "value" => date)
        # default, not important, required
        builder.field("id" => "orderpriority", "value" => "2")
        builder.field("id" => "orderschedulefreetext", "value" => "")
        builder.field("id" => "orderschedulerecurring", "value" => "")
        builder.field("id" => "orderschedulerecurringperiod", "value" => "")
        builder.field("id" => "orderschedulestarting", "value" => date)
        builder.field("id" => "orderscheduleending", "value" => date)
        builder.field("id" => "orderscheduleendingafter", "value" => "")
        builder.field("id" => "orderperformingcomment", "value" => "")
        builder.field("id" => "ordercommunicatedby", "value" => 11) # hard coded
        builder.field("id" => "orderorderedby", "value" => emr_user_id)
        builder.field("id" => "ordermanagedby", "value" => emr_user_id)
        builder.field("id" => "ordersupervisedby", "value" => "")
        builder.field("id" => "orderciteresult", "value" => "")
        builder.field("id" => "orderannotation", "value" => "")
        builder.field("id" => "orderstatus", "value" => "Active")
        builder.field("id" => "orderstatusdate", "value" => date)
        builder.field("id" => "orderdeferralinterval", "value" => 0)
        builder.field("id" => "orderdeferralunit", "value" => "Days")
        builder.field("id" => "orderstatusreason", "value" => "")
        builder.field("id" => "encounter", "value" => encounter_id.to_s)
        builder.orderlinkedproblems
        builder.clinicalquestions
      end

      builder.to_xml
    end
  end
end
