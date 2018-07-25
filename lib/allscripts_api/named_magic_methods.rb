# frozen_string_literal: true

module AllscriptsApi
  # A collection of named convenience methods that map
  # to Allscripts magic actions. These methods are included
  # in `AllscriptsApi::Client` and can be accessed from
  # instances of that class.
  module NamedMagicMethods
    # a wrapper around GetProvider
    #
    # @param provider_id [String] optional Allscripts user id
    # @param user_name [String] optional Allscripts user_name
    # @return [Array<Hash>, Array, MagicError] a list of providers
    def get_provider(provider_id = nil, user_name = nil)
      params =
        MagicParams.format(
          parameter1: provider_id,
          parameter2: user_name
        )
      results = magic("GetProvider", magic_params: params)
      results["getproviderinfo"]
    end

    # a wrapper around GetProviders
    #
    # @param security_filter [String] optional EntryCode of the Security_Code_DE dictionary for the providers being sought. A list of valid security codes can be obtained from GetDictionary on the Security_Code_DE dictionary.
    # @param name_filter [String] optional If specified, will filter for providers with a lastname or entrycode that match. Defaults to %.
    # @param show_only_providers_flag [String] optional (Y/N) Indicate whether or not to return only users that are also Providers. Defaults to Y.
    # @param internal_external [String] optional I for Internal (User/providers that are internal to the enterprise). E for External (Referring physicians). Defaults to I.
    # @param ordering_authority [String] optional Show only those users with an ordering provider level of X (which is a number)
    # @param real_provider [String] optional Whether an NPI (National Provider ID) is required (Y/N). Y returns only actual providers. Default is N.
    # @return [Array<Hash>, Array, MagicError] a list of providers
    def get_providers(security_filter = nil,
                      name_filter = nil,
                      show_only_providers_flag = "Y",
                      internal_external = "I",
                      ordering_authority = nil,
                      real_provider = "N")
      params =
        MagicParams.format(
          parameter1: security_filter,
          parameter2: name_filter,
          parameter3: show_only_providers_flag,
          parameter4: internal_external,
          parameter5: ordering_authority,
          parameter6: real_provider
        )
      results = magic("GetProviders", magic_params: params)
      results["getprovidersinfo"]
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


    # a wrapper around GetResults
    #
    # @param patient_id [String] patient id
    # @param since [String] Specify a date/time combination to return only results that have been modified on or after that date/time. For example, 2014-01-01 or 2015-01-14 08:44:28.563. Defaults to nil
    # @return [Array<Hash>, Array, MagicError] a list of found results (lab/imaging),
    # an empty array, or an error
    def get_results(patient_id,
                    since = nil)
      params = MagicParams.format(
        user_id: @allscripts_username,
        patient_id: patient_id,
        parameter1: since
      )
      results = magic("GetResults", magic_params: params)
      results["getresultsinfo"]
    end

    # a wrapper around GetSchedule, returns appointments scheduled under the
    # the user for a given date range
    #
    # @param start_date [Date] start date inclusive
    # @param end_date [Date] end date inclusive
    # @return [Array<Hash>, Array, MagicError] a list of scheduled appointments, an empty array, or an error
    def get_schedule(start_date, end_date)
      params =
        MagicParams.format(
          user_id: @allscripts_username,
          parameter1: format_date_range(start_date, end_date)
        )
      results = magic("GetSchedule", magic_params: params)
      results["getscheduleinfo"]
    end

    # a wrapper around GetEncounterList
    #
    # @param patient_id [String] patient id
    # @param encounter_type [String] encounter type to filter on from Encounter_Type_DE
    # @param when_or_limit [String] filter by specified date
    # @param nostradamus [String] how many days to look into the future. Defaults to 0.
    # @param show_past_flag [String] show previous encounters, "Y" or "N". Defaults to Y
    # @param billing_provider_user_name [String] filter by user name (if specified)
    # @return [Array<Hash>, Array, MagicError] a list of encounters
    def get_encounter_list(patient_id = "", encounter_type = "",
                           when_or_limit = "", nostradamus = 0,
                           show_past_flag = "Y",
                           billing_provider_user_name = "")
      params =
        MagicParams.format(
          user_id: @allscripts_username,
          patient_id: patient_id,
          parameter1: encounter_type, # from Encounter_Type_DE
          parameter2: when_or_limit,
          parameter3: nostradamus,
          parameter4: show_past_flag,
          parameter5: billing_provider_user_name,
        )
      results = magic("GetEncounterList", magic_params: params)
      results["getencounterlistinfo"]
    end

    # a wrapper around GetListOfDictionaries, which returns
    # list of all dictionaries
    #
    # @return [Array<Hash>, Array, MagicError] a list of found dictionaries,
    # an empty array, or an error
    def get_list_of_dictionaries
      params = MagicParams.format(user_id: @allscripts_username)
      results = magic("GetListOfDictionaries", magic_params: params)
      results["getlistofdictionariesinfo"]
    end

    # a wrapper around GetDictionary, which returnsentries
    # from a specific dictionary.
    #
    # @param dictionary_name [String] the name of the desired dictionary,
    # a "TableName" value from `get_list_of_dictionaries`
    # @return [Array<Hash>, Array, MagicError] a list dictionary entries,
    # an empty array, or an error
    def get_dictionary(dictionary_name)
      params = MagicParams.format(
        user_id: @allscripts_username,
        parameter1: dictionary_name
      )
      results = magic("GetDictionary", magic_params: params)
      results["getdictionaryinfo"]
    end

    # a wrapper around GetServerInfo, which returns
    # the time zone of the server, unity version and date
    # and license key
    #
    # @return [Array<Hash>, Array, MagicError]  local information about the
    # server hosting the Unity webservice.
    def get_server_info
      params = MagicParams.format(user_id: @allscripts_username)
      results = magic("GetServerInfo", magic_params: params)
      results["getserverinfoinfo"][0] # infoinfo is an Allscript typo
    end

    def last_logs(errors_only = "N", show_wand = "N", how_many = 10, start_time = "", end_time = "")
      params =
        MagicParams.format(
          parameter1: errors_only,
          parameter2: show_wand,
          parameter3: how_many,
          parameter4: start_time,
          parameter5: end_time
        )
      results = magic("LastLogs", magic_params: params)
    end

    private

    def format_date_range(start_date, end_date)
      "#{start_date.strftime('%m/%d/%Y')}|#{end_date.strftime('%m/%d/%Y')}"
    end
  end
end
