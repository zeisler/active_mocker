require 'active_mocker/mock_instance_methods'
require 'active_mocker/mock_class_methods'
require 'active_hash'
require 'active_hash/ar_api'

class PlanMock < ::ActiveHash::Base
  include ActiveMocker::ActiveHash::ARApi
  include ActiveMocker::MockInstanceMethods
  extend  ActiveMocker::MockClassMethods

  def self.column_names
    ["id", "plan_id_legacy", "name", "plan_number", "user_id_owner", "form5500_id", "user_id_primary_sponsor_contact", "user_id_recordkeeper", "user_id_tpa", "user_id_advisor", "company_id_sponsor", "ein_plan_code", "plan_number_3_digit", "customer_identifier", "disclosure_name", "disclosure_assets", "disclosure_participants", "user_id_recordkeeper_disclosure", "user_id_tpa_disclosure", "disclosure_fiduciary_status", "prospect_plan", "split_id", "is_advisor_12b1_broker", "twelveb1_dispersal_id", "user_id_referred_by", "logo_location", "advisor_fee_support_location", "rank_factor_investments", "rank_factor_vendor_mgmt", "rank_factor_plan_mgmt", "rank_factor_part_services", "rank_factor_plan_complexity", "rank_factor_recordkeeping", "rank_factor_administration", "rank_factor_compliance_consulting", "rank_factor_communication_education", "total_advisable_plan_assets", "total_proprietary_plan_assets", "is_held_away", "brokerage_assets_12_months_ago", "participant_internet_capability", "annual_per_participant_advice_fee", "percent_assets_in_target_date_funds", "percent_assets_in_risk_based_funds_or_balanced_funds", "percent_assets_in_model_portfolios_from_core", "percent_assets_in_managed_accounts", "percent_delegators", "percent_doers_diversified", "percent_doers_auto_rebalance", "percent_doers_diversified_and_auto_rebalance", "percent_with_a_loan", "percent_taking_loan_last_12mos", "percent_taking_age_59_5_withdrawal_last_12mos", "percent_taking_hardship_withdrawal_last_12mos", "percent_terms_dollars_of_last_12_mos_preserving_percent_resp", "duns_number", "assets_as_of_date", "redacted_plan_number", "redacted_sponsor_ein", "contract_id_future", "is_active", "creation_date", "termination_date", "contract_expiration_date", "last_comprehensive_review_date", "naics_code", "plan_type_id", "is_csp_408b2", "total_plan_assets", "loan_assets", "revenue_method_id", "erisa_remainder", "trustee_custodian_code", "trustee_custodian_name", "employer_controlled_group", "eligible_age_service_single_requirement", "eligible_age_service_multiple_requirement", "eligible_age_single_requirement", "eligible_age_multiple_requirement", "entry_date", "autoenroll", "autoenroll_percent", "autoincrease_annual_max", "autoincrease_overall_max", "pretax_max_percent", "roth_max_percent", "catchup", "aftertax_max_percent", "rollover_in", "employer_matching", "employer_matching_formula_type", "employer_matching_tier1_percent", "employer_matching_tier1_amount_percent", "employer_matching_tier1_amount_amt", "employer_matching_tier2_percent", "employer_matching_tier2_amount_percent", "employer_matching_tier2_amount_amt", "employer_matching_tier3_percent", "employer_matching_tier3_amount_percent", "employer_matching_tier3_amount_amt", "employer_matching_formula_amtmax_applies", "employer_matching_formula_amtmax_amount", "employer_matching_trueup", "employer_matching_eoy", "employer_matching_1000_hrs", "employer_matching_vesting", "employer_matching_vesting_years", "employer_required", "employer_required_amtmax_applies", "employer_required_amtmax_amount", "employer_required_percent", "employer_required_eoy", "employer_required_1000_hrs", "employer_required_vesting", "employer_required_vesting_years", "employer_discretionary", "employer_discretionary_percent", "employer_discretionary_amtmax_applies", "employer_discretionary_amtmax_amount", "employer_discretionary_eoy", "employer_discretionary_1000_hrs", "employer_discretionary_vesting", "employer_discretionary_years", "model_strategy_id", "models_number", "all_employees_defaulted_into_qdia", "auto_rebalance", "loans_allowed_general_purpose", "loans_allowed_home", "loans_allowed_hardship", "max_loans", "age_59_5_withdrawals", "hardship_withdrawals", "installment_payments", "annuity_option", "cash_out", "lifetime_income_option", "lifetime_income_service", "valuation_frequency", "startup_startup_newlyeligible_volumes", "m_and_a_volumes_acquisitions", "m_and_a_volumes_divestitures", "ineligible_participants_volumes", "eligible_participants_volumes", "active_participants_account_balance", "terminated_participants_account_balance", "participant_count", "processing_payroll_volumes", "processing_employer_match_volumes", "processing_employer_other_volumes", "deferral_rate_changes_manual", "deferral_rate_changes_automated", "processing_forfeiture_allocations", "processing_corrected_contributions", "processing_adp_acp_refunds", "processing_adp_acp_contributions", "rollover_in_volumes", "investment_transfer_volumes", "loan_origination_volumes", "loans_maintenance_volumes", "age_59_5_volumes", "hardship_process_volumes", "mrds_volumes", "qdro_process_volumes", "distributions_processed_volumes", "distributions_processed_volumes_cashout", "fund_adds_volumes", "fund_deletes_volumes", "company_stock", "company_stock_dividend_allocation", "company_stock_dividend_type", "models_nav_type", "support_annual_audit", "plan_design_changes_volumes", "implement_plan_startup_processes", "provide_plan_document_spd", "provide_plan_document_amendments", "determine_newly_eligible_employees", "send_enrollment_materials_hardcopy", "send_enrollment_materials_digital", "census_validation_for_payroll", "calculate_employer_match_volumes", "calculate_employer_match_trueup", "calculate_other_employer_contribution", "calculate_forfeiture_allocation", "forfeiture_allocations_type", "distribute_required_notices_digital", "distribute_required_notices_hardcopy", "distribute_404a5_participant_disclosures", "calculate_contribution_corrections", "rollover_in_review", "loan_origination_review", "hardship_review", "age_59_5_review", "mrds_review", "qdro_review", "terms_review", "administer_erisa_spending_accounts", "erisa_spending_accounts_usage", "prepare_form_5500", "conducts_adp_acp_testing", "adp_acp_testing_type", "calculate_adp_acp_refunds", "calculate_adp_acp_contributions", "conducts_415_testing", "conducts_top_heavy_testing", "calculate_top_heavy_minimum", "conducts_compensation_ratio_testing", "calculates_eligible_compensation_of_self_employed", "definition_of_compensation", "meet_with_plan_committee", "type_of_plan_committee_meetings", "conducts_401a4_testing", "conducts_410b_testing", "monitor_section_16_insider_trading_rules", "type_of_section_16_insider_trading_window", "consult_on_plan_design_changes", "merger_and_acquisition_work", "assist_with_irs_and_dol_audits", "consult_on_plan_defect_correction", "manage_plan_transition_to_new_vendor", "enrollment_kit_volumes", "mail_s_enrollment_kit_type", "toll_free_number_recordkeepers_volumes", "toll_free_number_recordkeepers_type", "internet_participants_type", "hardcopy_statement_volumes", "hardcopy_statement_type", "digital_stmts_volumes", "digital_stmts_type", "retirement_projection_hardcopy_statement_volumes", "retirement_projection_hardcopy_statement_type", "retirement_projection_digital_statement_volumes", "retirement_projection_digital_statement_type", "hardcopy_plan_driven_events", "hardcopy_plan_driven_events_type", "digital_plan_driven_events", "digital_plan_driven_events_type", "hardcopy_campaigns", "hardcopy_campaign_type", "digital_campaigns", "digital_campaign_type", "group_meetings", "group_meetings_type", "one_on_one_meetings", "one_on_one_meetings_type", "participation_pre_tax_rate_overall", "participation_pre_tax_rate_hces", "participation_pre_tax_rate_nhces", "pre_tax_deferral_percent_overall", "pre_tax_deferral_percent_hces", "pre_tax_deferral_percent_nhces", "participation_roth_rate_overall", "participation_roth_rate_hces", "participation_roth_rate_nhces", "roth_deferral_percent_overall", "roth_deferral_percent_hces", "roth_deferral_percent_nhces", "auto_escalate_percent_parts", "auto_escalate_avg_increase", "max_company_match_percent_parts", "catchup_percent_parts", "dollars_in_models", "terms_volumes", "terms_still_in_plan_percent_parts_12mos", "terms_rolled_over_percent_parts_12mos", "terms_cashed_out_percent_parts_12mos", "terms_still_in_plan_amt_12mos", "terms_rolled_over_amt_12mos", "terms_cashed_out_amt_12mos", "advisor_twelve_b1_fees_broker_of_record", "advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions", "participation_pre_tax_deferral_percent_hces", "participation_pre_tax_deferral_percent_nhces", "created_at", "updated_at", "company_id_recordkeeper", "company_id_tpa", "company_id_advisor_firm", "person_id_advisor", "advisor_makes_payments_to_providers", "advisor_credits_plan_or_participants", "service_group_id"]
  end

  def self.association_names
    @association_names = []
  end

  def self.attribute_names
    @attribute_names = [:id, :plan_id_legacy, :name, :plan_number, :user_id_owner, :form5500_id, :user_id_primary_sponsor_contact, :user_id_recordkeeper, :user_id_tpa, :user_id_advisor, :company_id_sponsor, :ein_plan_code, :plan_number_3_digit, :customer_identifier, :disclosure_name, :disclosure_assets, :disclosure_participants, :user_id_recordkeeper_disclosure, :user_id_tpa_disclosure, :disclosure_fiduciary_status, :prospect_plan, :split_id, :is_advisor_12b1_broker, :twelveb1_dispersal_id, :user_id_referred_by, :logo_location, :advisor_fee_support_location, :rank_factor_investments, :rank_factor_vendor_mgmt, :rank_factor_plan_mgmt, :rank_factor_part_services, :rank_factor_plan_complexity, :rank_factor_recordkeeping, :rank_factor_administration, :rank_factor_compliance_consulting, :rank_factor_communication_education, :total_advisable_plan_assets, :total_proprietary_plan_assets, :is_held_away, :brokerage_assets_12_months_ago, :participant_internet_capability, :annual_per_participant_advice_fee, :percent_assets_in_target_date_funds, :percent_assets_in_risk_based_funds_or_balanced_funds, :percent_assets_in_model_portfolios_from_core, :percent_assets_in_managed_accounts, :percent_delegators, :percent_doers_diversified, :percent_doers_auto_rebalance, :percent_doers_diversified_and_auto_rebalance, :percent_with_a_loan, :percent_taking_loan_last_12mos, :percent_taking_age_59_5_withdrawal_last_12mos, :percent_taking_hardship_withdrawal_last_12mos, :percent_terms_dollars_of_last_12_mos_preserving_percent_resp, :duns_number, :assets_as_of_date, :redacted_plan_number, :redacted_sponsor_ein, :contract_id_future, :is_active, :creation_date, :termination_date, :contract_expiration_date, :last_comprehensive_review_date, :naics_code, :plan_type_id, :is_csp_408b2, :total_plan_assets, :loan_assets, :revenue_method_id, :erisa_remainder, :trustee_custodian_code, :trustee_custodian_name, :employer_controlled_group, :eligible_age_service_single_requirement, :eligible_age_service_multiple_requirement, :eligible_age_single_requirement, :eligible_age_multiple_requirement, :entry_date, :autoenroll, :autoenroll_percent, :autoincrease_annual_max, :autoincrease_overall_max, :pretax_max_percent, :roth_max_percent, :catchup, :aftertax_max_percent, :rollover_in, :employer_matching, :employer_matching_formula_type, :employer_matching_tier1_percent, :employer_matching_tier1_amount_percent, :employer_matching_tier1_amount_amt, :employer_matching_tier2_percent, :employer_matching_tier2_amount_percent, :employer_matching_tier2_amount_amt, :employer_matching_tier3_percent, :employer_matching_tier3_amount_percent, :employer_matching_tier3_amount_amt, :employer_matching_formula_amtmax_applies, :employer_matching_formula_amtmax_amount, :employer_matching_trueup, :employer_matching_eoy, :employer_matching_1000_hrs, :employer_matching_vesting, :employer_matching_vesting_years, :employer_required, :employer_required_amtmax_applies, :employer_required_amtmax_amount, :employer_required_percent, :employer_required_eoy, :employer_required_1000_hrs, :employer_required_vesting, :employer_required_vesting_years, :employer_discretionary, :employer_discretionary_percent, :employer_discretionary_amtmax_applies, :employer_discretionary_amtmax_amount, :employer_discretionary_eoy, :employer_discretionary_1000_hrs, :employer_discretionary_vesting, :employer_discretionary_years, :model_strategy_id, :models_number, :all_employees_defaulted_into_qdia, :auto_rebalance, :loans_allowed_general_purpose, :loans_allowed_home, :loans_allowed_hardship, :max_loans, :age_59_5_withdrawals, :hardship_withdrawals, :installment_payments, :annuity_option, :cash_out, :lifetime_income_option, :lifetime_income_service, :valuation_frequency, :startup_startup_newlyeligible_volumes, :m_and_a_volumes_acquisitions, :m_and_a_volumes_divestitures, :ineligible_participants_volumes, :eligible_participants_volumes, :active_participants_account_balance, :terminated_participants_account_balance, :participant_count, :processing_payroll_volumes, :processing_employer_match_volumes, :processing_employer_other_volumes, :deferral_rate_changes_manual, :deferral_rate_changes_automated, :processing_forfeiture_allocations, :processing_corrected_contributions, :processing_adp_acp_refunds, :processing_adp_acp_contributions, :rollover_in_volumes, :investment_transfer_volumes, :loan_origination_volumes, :loans_maintenance_volumes, :age_59_5_volumes, :hardship_process_volumes, :mrds_volumes, :qdro_process_volumes, :distributions_processed_volumes, :distributions_processed_volumes_cashout, :fund_adds_volumes, :fund_deletes_volumes, :company_stock, :company_stock_dividend_allocation, :company_stock_dividend_type, :models_nav_type, :support_annual_audit, :plan_design_changes_volumes, :implement_plan_startup_processes, :provide_plan_document_spd, :provide_plan_document_amendments, :determine_newly_eligible_employees, :send_enrollment_materials_hardcopy, :send_enrollment_materials_digital, :census_validation_for_payroll, :calculate_employer_match_volumes, :calculate_employer_match_trueup, :calculate_other_employer_contribution, :calculate_forfeiture_allocation, :forfeiture_allocations_type, :distribute_required_notices_digital, :distribute_required_notices_hardcopy, :distribute_404a5_participant_disclosures, :calculate_contribution_corrections, :rollover_in_review, :loan_origination_review, :hardship_review, :age_59_5_review, :mrds_review, :qdro_review, :terms_review, :administer_erisa_spending_accounts, :erisa_spending_accounts_usage, :prepare_form_5500, :conducts_adp_acp_testing, :adp_acp_testing_type, :calculate_adp_acp_refunds, :calculate_adp_acp_contributions, :conducts_415_testing, :conducts_top_heavy_testing, :calculate_top_heavy_minimum, :conducts_compensation_ratio_testing, :calculates_eligible_compensation_of_self_employed, :definition_of_compensation, :meet_with_plan_committee, :type_of_plan_committee_meetings, :conducts_401a4_testing, :conducts_410b_testing, :monitor_section_16_insider_trading_rules, :type_of_section_16_insider_trading_window, :consult_on_plan_design_changes, :merger_and_acquisition_work, :assist_with_irs_and_dol_audits, :consult_on_plan_defect_correction, :manage_plan_transition_to_new_vendor, :enrollment_kit_volumes, :mail_s_enrollment_kit_type, :toll_free_number_recordkeepers_volumes, :toll_free_number_recordkeepers_type, :internet_participants_type, :hardcopy_statement_volumes, :hardcopy_statement_type, :digital_stmts_volumes, :digital_stmts_type, :retirement_projection_hardcopy_statement_volumes, :retirement_projection_hardcopy_statement_type, :retirement_projection_digital_statement_volumes, :retirement_projection_digital_statement_type, :hardcopy_plan_driven_events, :hardcopy_plan_driven_events_type, :digital_plan_driven_events, :digital_plan_driven_events_type, :hardcopy_campaigns, :hardcopy_campaign_type, :digital_campaigns, :digital_campaign_type, :group_meetings, :group_meetings_type, :one_on_one_meetings, :one_on_one_meetings_type, :participation_pre_tax_rate_overall, :participation_pre_tax_rate_hces, :participation_pre_tax_rate_nhces, :pre_tax_deferral_percent_overall, :pre_tax_deferral_percent_hces, :pre_tax_deferral_percent_nhces, :participation_roth_rate_overall, :participation_roth_rate_hces, :participation_roth_rate_nhces, :roth_deferral_percent_overall, :roth_deferral_percent_hces, :roth_deferral_percent_nhces, :auto_escalate_percent_parts, :auto_escalate_avg_increase, :max_company_match_percent_parts, :catchup_percent_parts, :dollars_in_models, :terms_volumes, :terms_still_in_plan_percent_parts_12mos, :terms_rolled_over_percent_parts_12mos, :terms_cashed_out_percent_parts_12mos, :terms_still_in_plan_amt_12mos, :terms_rolled_over_amt_12mos, :terms_cashed_out_amt_12mos, :advisor_twelve_b1_fees_broker_of_record, :advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions, :participation_pre_tax_deferral_percent_hces, :participation_pre_tax_deferral_percent_nhces, :created_at, :updated_at, :company_id_recordkeeper, :company_id_tpa, :company_id_advisor_firm, :person_id_advisor, :advisor_makes_payments_to_providers, :advisor_credits_plan_or_participants, :service_group_id]
  end


  def id
    attributes['id']
  end

  def id=(val)
    attributes['id'] = val
  end

  def plan_id_legacy
    attributes['plan_id_legacy']
  end

  def plan_id_legacy=(val)
    attributes['plan_id_legacy'] = val
  end

  def name
    attributes['name']
  end

  def name=(val)
    attributes['name'] = val
  end

  def plan_number
    attributes['plan_number']
  end

  def plan_number=(val)
    attributes['plan_number'] = val
  end

  def user_id_owner
    attributes['user_id_owner']
  end

  def user_id_owner=(val)
    attributes['user_id_owner'] = val
  end

  def form5500_id
    attributes['form5500_id']
  end

  def form5500_id=(val)
    attributes['form5500_id'] = val
  end

  def user_id_primary_sponsor_contact
    attributes['user_id_primary_sponsor_contact']
  end

  def user_id_primary_sponsor_contact=(val)
    attributes['user_id_primary_sponsor_contact'] = val
  end

  def user_id_recordkeeper
    attributes['user_id_recordkeeper']
  end

  def user_id_recordkeeper=(val)
    attributes['user_id_recordkeeper'] = val
  end

  def user_id_tpa
    attributes['user_id_tpa']
  end

  def user_id_tpa=(val)
    attributes['user_id_tpa'] = val
  end

  def user_id_advisor
    attributes['user_id_advisor']
  end

  def user_id_advisor=(val)
    attributes['user_id_advisor'] = val
  end

  def company_id_sponsor
    attributes['company_id_sponsor']
  end

  def company_id_sponsor=(val)
    attributes['company_id_sponsor'] = val
  end

  def ein_plan_code
    attributes['ein_plan_code']
  end

  def ein_plan_code=(val)
    attributes['ein_plan_code'] = val
  end

  def plan_number_3_digit
    attributes['plan_number_3_digit']
  end

  def plan_number_3_digit=(val)
    attributes['plan_number_3_digit'] = val
  end

  def customer_identifier
    attributes['customer_identifier']
  end

  def customer_identifier=(val)
    attributes['customer_identifier'] = val
  end

  def disclosure_name
    attributes['disclosure_name']
  end

  def disclosure_name=(val)
    attributes['disclosure_name'] = val
  end

  def disclosure_assets
    attributes['disclosure_assets']
  end

  def disclosure_assets=(val)
    attributes['disclosure_assets'] = val
  end

  def disclosure_participants
    attributes['disclosure_participants']
  end

  def disclosure_participants=(val)
    attributes['disclosure_participants'] = val
  end

  def user_id_recordkeeper_disclosure
    attributes['user_id_recordkeeper_disclosure']
  end

  def user_id_recordkeeper_disclosure=(val)
    attributes['user_id_recordkeeper_disclosure'] = val
  end

  def user_id_tpa_disclosure
    attributes['user_id_tpa_disclosure']
  end

  def user_id_tpa_disclosure=(val)
    attributes['user_id_tpa_disclosure'] = val
  end

  def disclosure_fiduciary_status
    attributes['disclosure_fiduciary_status']
  end

  def disclosure_fiduciary_status=(val)
    attributes['disclosure_fiduciary_status'] = val
  end

  def prospect_plan
    attributes['prospect_plan']
  end

  def prospect_plan=(val)
    attributes['prospect_plan'] = val
  end

  def split_id
    attributes['split_id']
  end

  def split_id=(val)
    attributes['split_id'] = val
  end

  def is_advisor_12b1_broker
    attributes['is_advisor_12b1_broker']
  end

  def is_advisor_12b1_broker=(val)
    attributes['is_advisor_12b1_broker'] = val
  end

  def twelveb1_dispersal_id
    attributes['twelveb1_dispersal_id']
  end

  def twelveb1_dispersal_id=(val)
    attributes['twelveb1_dispersal_id'] = val
  end

  def user_id_referred_by
    attributes['user_id_referred_by']
  end

  def user_id_referred_by=(val)
    attributes['user_id_referred_by'] = val
  end

  def logo_location
    attributes['logo_location']
  end

  def logo_location=(val)
    attributes['logo_location'] = val
  end

  def advisor_fee_support_location
    attributes['advisor_fee_support_location']
  end

  def advisor_fee_support_location=(val)
    attributes['advisor_fee_support_location'] = val
  end

  def rank_factor_investments
    attributes['rank_factor_investments']
  end

  def rank_factor_investments=(val)
    attributes['rank_factor_investments'] = val
  end

  def rank_factor_vendor_mgmt
    attributes['rank_factor_vendor_mgmt']
  end

  def rank_factor_vendor_mgmt=(val)
    attributes['rank_factor_vendor_mgmt'] = val
  end

  def rank_factor_plan_mgmt
    attributes['rank_factor_plan_mgmt']
  end

  def rank_factor_plan_mgmt=(val)
    attributes['rank_factor_plan_mgmt'] = val
  end

  def rank_factor_part_services
    attributes['rank_factor_part_services']
  end

  def rank_factor_part_services=(val)
    attributes['rank_factor_part_services'] = val
  end

  def rank_factor_plan_complexity
    attributes['rank_factor_plan_complexity']
  end

  def rank_factor_plan_complexity=(val)
    attributes['rank_factor_plan_complexity'] = val
  end

  def rank_factor_recordkeeping
    attributes['rank_factor_recordkeeping']
  end

  def rank_factor_recordkeeping=(val)
    attributes['rank_factor_recordkeeping'] = val
  end

  def rank_factor_administration
    attributes['rank_factor_administration']
  end

  def rank_factor_administration=(val)
    attributes['rank_factor_administration'] = val
  end

  def rank_factor_compliance_consulting
    attributes['rank_factor_compliance_consulting']
  end

  def rank_factor_compliance_consulting=(val)
    attributes['rank_factor_compliance_consulting'] = val
  end

  def rank_factor_communication_education
    attributes['rank_factor_communication_education']
  end

  def rank_factor_communication_education=(val)
    attributes['rank_factor_communication_education'] = val
  end

  def total_advisable_plan_assets
    attributes['total_advisable_plan_assets']
  end

  def total_advisable_plan_assets=(val)
    attributes['total_advisable_plan_assets'] = val
  end

  def total_proprietary_plan_assets
    attributes['total_proprietary_plan_assets']
  end

  def total_proprietary_plan_assets=(val)
    attributes['total_proprietary_plan_assets'] = val
  end

  def is_held_away
    attributes['is_held_away']
  end

  def is_held_away=(val)
    attributes['is_held_away'] = val
  end

  def brokerage_assets_12_months_ago
    attributes['brokerage_assets_12_months_ago']
  end

  def brokerage_assets_12_months_ago=(val)
    attributes['brokerage_assets_12_months_ago'] = val
  end

  def participant_internet_capability
    attributes['participant_internet_capability']
  end

  def participant_internet_capability=(val)
    attributes['participant_internet_capability'] = val
  end

  def annual_per_participant_advice_fee
    attributes['annual_per_participant_advice_fee']
  end

  def annual_per_participant_advice_fee=(val)
    attributes['annual_per_participant_advice_fee'] = val
  end

  def percent_assets_in_target_date_funds
    attributes['percent_assets_in_target_date_funds']
  end

  def percent_assets_in_target_date_funds=(val)
    attributes['percent_assets_in_target_date_funds'] = val
  end

  def percent_assets_in_risk_based_funds_or_balanced_funds
    attributes['percent_assets_in_risk_based_funds_or_balanced_funds']
  end

  def percent_assets_in_risk_based_funds_or_balanced_funds=(val)
    attributes['percent_assets_in_risk_based_funds_or_balanced_funds'] = val
  end

  def percent_assets_in_model_portfolios_from_core
    attributes['percent_assets_in_model_portfolios_from_core']
  end

  def percent_assets_in_model_portfolios_from_core=(val)
    attributes['percent_assets_in_model_portfolios_from_core'] = val
  end

  def percent_assets_in_managed_accounts
    attributes['percent_assets_in_managed_accounts']
  end

  def percent_assets_in_managed_accounts=(val)
    attributes['percent_assets_in_managed_accounts'] = val
  end

  def percent_delegators
    attributes['percent_delegators']
  end

  def percent_delegators=(val)
    attributes['percent_delegators'] = val
  end

  def percent_doers_diversified
    attributes['percent_doers_diversified']
  end

  def percent_doers_diversified=(val)
    attributes['percent_doers_diversified'] = val
  end

  def percent_doers_auto_rebalance
    attributes['percent_doers_auto_rebalance']
  end

  def percent_doers_auto_rebalance=(val)
    attributes['percent_doers_auto_rebalance'] = val
  end

  def percent_doers_diversified_and_auto_rebalance
    attributes['percent_doers_diversified_and_auto_rebalance']
  end

  def percent_doers_diversified_and_auto_rebalance=(val)
    attributes['percent_doers_diversified_and_auto_rebalance'] = val
  end

  def percent_with_a_loan
    attributes['percent_with_a_loan']
  end

  def percent_with_a_loan=(val)
    attributes['percent_with_a_loan'] = val
  end

  def percent_taking_loan_last_12mos
    attributes['percent_taking_loan_last_12mos']
  end

  def percent_taking_loan_last_12mos=(val)
    attributes['percent_taking_loan_last_12mos'] = val
  end

  def percent_taking_age_59_5_withdrawal_last_12mos
    attributes['percent_taking_age_59_5_withdrawal_last_12mos']
  end

  def percent_taking_age_59_5_withdrawal_last_12mos=(val)
    attributes['percent_taking_age_59_5_withdrawal_last_12mos'] = val
  end

  def percent_taking_hardship_withdrawal_last_12mos
    attributes['percent_taking_hardship_withdrawal_last_12mos']
  end

  def percent_taking_hardship_withdrawal_last_12mos=(val)
    attributes['percent_taking_hardship_withdrawal_last_12mos'] = val
  end

  def percent_terms_dollars_of_last_12_mos_preserving_percent_resp
    attributes['percent_terms_dollars_of_last_12_mos_preserving_percent_resp']
  end

  def percent_terms_dollars_of_last_12_mos_preserving_percent_resp=(val)
    attributes['percent_terms_dollars_of_last_12_mos_preserving_percent_resp'] = val
  end

  def duns_number
    attributes['duns_number']
  end

  def duns_number=(val)
    attributes['duns_number'] = val
  end

  def assets_as_of_date
    attributes['assets_as_of_date']
  end

  def assets_as_of_date=(val)
    attributes['assets_as_of_date'] = val
  end

  def redacted_plan_number
    attributes['redacted_plan_number']
  end

  def redacted_plan_number=(val)
    attributes['redacted_plan_number'] = val
  end

  def redacted_sponsor_ein
    attributes['redacted_sponsor_ein']
  end

  def redacted_sponsor_ein=(val)
    attributes['redacted_sponsor_ein'] = val
  end

  def contract_id_future
    attributes['contract_id_future']
  end

  def contract_id_future=(val)
    attributes['contract_id_future'] = val
  end

  def is_active
    attributes['is_active']
  end

  def is_active=(val)
    attributes['is_active'] = val
  end

  def creation_date
    attributes['creation_date']
  end

  def creation_date=(val)
    attributes['creation_date'] = val
  end

  def termination_date
    attributes['termination_date']
  end

  def termination_date=(val)
    attributes['termination_date'] = val
  end

  def contract_expiration_date
    attributes['contract_expiration_date']
  end

  def contract_expiration_date=(val)
    attributes['contract_expiration_date'] = val
  end

  def last_comprehensive_review_date
    attributes['last_comprehensive_review_date']
  end

  def last_comprehensive_review_date=(val)
    attributes['last_comprehensive_review_date'] = val
  end

  def naics_code
    attributes['naics_code']
  end

  def naics_code=(val)
    attributes['naics_code'] = val
  end

  def plan_type_id
    attributes['plan_type_id']
  end

  def plan_type_id=(val)
    attributes['plan_type_id'] = val
  end

  def is_csp_408b2
    attributes['is_csp_408b2']
  end

  def is_csp_408b2=(val)
    attributes['is_csp_408b2'] = val
  end

  def total_plan_assets
    attributes['total_plan_assets']
  end

  def total_plan_assets=(val)
    attributes['total_plan_assets'] = val
  end

  def loan_assets
    attributes['loan_assets']
  end

  def loan_assets=(val)
    attributes['loan_assets'] = val
  end

  def revenue_method_id
    attributes['revenue_method_id']
  end

  def revenue_method_id=(val)
    attributes['revenue_method_id'] = val
  end

  def erisa_remainder
    attributes['erisa_remainder']
  end

  def erisa_remainder=(val)
    attributes['erisa_remainder'] = val
  end

  def trustee_custodian_code
    attributes['trustee_custodian_code']
  end

  def trustee_custodian_code=(val)
    attributes['trustee_custodian_code'] = val
  end

  def trustee_custodian_name
    attributes['trustee_custodian_name']
  end

  def trustee_custodian_name=(val)
    attributes['trustee_custodian_name'] = val
  end

  def employer_controlled_group
    attributes['employer_controlled_group']
  end

  def employer_controlled_group=(val)
    attributes['employer_controlled_group'] = val
  end

  def eligible_age_service_single_requirement
    attributes['eligible_age_service_single_requirement']
  end

  def eligible_age_service_single_requirement=(val)
    attributes['eligible_age_service_single_requirement'] = val
  end

  def eligible_age_service_multiple_requirement
    attributes['eligible_age_service_multiple_requirement']
  end

  def eligible_age_service_multiple_requirement=(val)
    attributes['eligible_age_service_multiple_requirement'] = val
  end

  def eligible_age_single_requirement
    attributes['eligible_age_single_requirement']
  end

  def eligible_age_single_requirement=(val)
    attributes['eligible_age_single_requirement'] = val
  end

  def eligible_age_multiple_requirement
    attributes['eligible_age_multiple_requirement']
  end

  def eligible_age_multiple_requirement=(val)
    attributes['eligible_age_multiple_requirement'] = val
  end

  def entry_date
    attributes['entry_date']
  end

  def entry_date=(val)
    attributes['entry_date'] = val
  end

  def autoenroll
    attributes['autoenroll']
  end

  def autoenroll=(val)
    attributes['autoenroll'] = val
  end

  def autoenroll_percent
    attributes['autoenroll_percent']
  end

  def autoenroll_percent=(val)
    attributes['autoenroll_percent'] = val
  end

  def autoincrease_annual_max
    attributes['autoincrease_annual_max']
  end

  def autoincrease_annual_max=(val)
    attributes['autoincrease_annual_max'] = val
  end

  def autoincrease_overall_max
    attributes['autoincrease_overall_max']
  end

  def autoincrease_overall_max=(val)
    attributes['autoincrease_overall_max'] = val
  end

  def pretax_max_percent
    attributes['pretax_max_percent']
  end

  def pretax_max_percent=(val)
    attributes['pretax_max_percent'] = val
  end

  def roth_max_percent
    attributes['roth_max_percent']
  end

  def roth_max_percent=(val)
    attributes['roth_max_percent'] = val
  end

  def catchup
    attributes['catchup']
  end

  def catchup=(val)
    attributes['catchup'] = val
  end

  def aftertax_max_percent
    attributes['aftertax_max_percent']
  end

  def aftertax_max_percent=(val)
    attributes['aftertax_max_percent'] = val
  end

  def rollover_in
    attributes['rollover_in']
  end

  def rollover_in=(val)
    attributes['rollover_in'] = val
  end

  def employer_matching
    attributes['employer_matching']
  end

  def employer_matching=(val)
    attributes['employer_matching'] = val
  end

  def employer_matching_formula_type
    attributes['employer_matching_formula_type']
  end

  def employer_matching_formula_type=(val)
    attributes['employer_matching_formula_type'] = val
  end

  def employer_matching_tier1_percent
    attributes['employer_matching_tier1_percent']
  end

  def employer_matching_tier1_percent=(val)
    attributes['employer_matching_tier1_percent'] = val
  end

  def employer_matching_tier1_amount_percent
    attributes['employer_matching_tier1_amount_percent']
  end

  def employer_matching_tier1_amount_percent=(val)
    attributes['employer_matching_tier1_amount_percent'] = val
  end

  def employer_matching_tier1_amount_amt
    attributes['employer_matching_tier1_amount_amt']
  end

  def employer_matching_tier1_amount_amt=(val)
    attributes['employer_matching_tier1_amount_amt'] = val
  end

  def employer_matching_tier2_percent
    attributes['employer_matching_tier2_percent']
  end

  def employer_matching_tier2_percent=(val)
    attributes['employer_matching_tier2_percent'] = val
  end

  def employer_matching_tier2_amount_percent
    attributes['employer_matching_tier2_amount_percent']
  end

  def employer_matching_tier2_amount_percent=(val)
    attributes['employer_matching_tier2_amount_percent'] = val
  end

  def employer_matching_tier2_amount_amt
    attributes['employer_matching_tier2_amount_amt']
  end

  def employer_matching_tier2_amount_amt=(val)
    attributes['employer_matching_tier2_amount_amt'] = val
  end

  def employer_matching_tier3_percent
    attributes['employer_matching_tier3_percent']
  end

  def employer_matching_tier3_percent=(val)
    attributes['employer_matching_tier3_percent'] = val
  end

  def employer_matching_tier3_amount_percent
    attributes['employer_matching_tier3_amount_percent']
  end

  def employer_matching_tier3_amount_percent=(val)
    attributes['employer_matching_tier3_amount_percent'] = val
  end

  def employer_matching_tier3_amount_amt
    attributes['employer_matching_tier3_amount_amt']
  end

  def employer_matching_tier3_amount_amt=(val)
    attributes['employer_matching_tier3_amount_amt'] = val
  end

  def employer_matching_formula_amtmax_applies
    attributes['employer_matching_formula_amtmax_applies']
  end

  def employer_matching_formula_amtmax_applies=(val)
    attributes['employer_matching_formula_amtmax_applies'] = val
  end

  def employer_matching_formula_amtmax_amount
    attributes['employer_matching_formula_amtmax_amount']
  end

  def employer_matching_formula_amtmax_amount=(val)
    attributes['employer_matching_formula_amtmax_amount'] = val
  end

  def employer_matching_trueup
    attributes['employer_matching_trueup']
  end

  def employer_matching_trueup=(val)
    attributes['employer_matching_trueup'] = val
  end

  def employer_matching_eoy
    attributes['employer_matching_eoy']
  end

  def employer_matching_eoy=(val)
    attributes['employer_matching_eoy'] = val
  end

  def employer_matching_1000_hrs
    attributes['employer_matching_1000_hrs']
  end

  def employer_matching_1000_hrs=(val)
    attributes['employer_matching_1000_hrs'] = val
  end

  def employer_matching_vesting
    attributes['employer_matching_vesting']
  end

  def employer_matching_vesting=(val)
    attributes['employer_matching_vesting'] = val
  end

  def employer_matching_vesting_years
    attributes['employer_matching_vesting_years']
  end

  def employer_matching_vesting_years=(val)
    attributes['employer_matching_vesting_years'] = val
  end

  def employer_required
    attributes['employer_required']
  end

  def employer_required=(val)
    attributes['employer_required'] = val
  end

  def employer_required_amtmax_applies
    attributes['employer_required_amtmax_applies']
  end

  def employer_required_amtmax_applies=(val)
    attributes['employer_required_amtmax_applies'] = val
  end

  def employer_required_amtmax_amount
    attributes['employer_required_amtmax_amount']
  end

  def employer_required_amtmax_amount=(val)
    attributes['employer_required_amtmax_amount'] = val
  end

  def employer_required_percent
    attributes['employer_required_percent']
  end

  def employer_required_percent=(val)
    attributes['employer_required_percent'] = val
  end

  def employer_required_eoy
    attributes['employer_required_eoy']
  end

  def employer_required_eoy=(val)
    attributes['employer_required_eoy'] = val
  end

  def employer_required_1000_hrs
    attributes['employer_required_1000_hrs']
  end

  def employer_required_1000_hrs=(val)
    attributes['employer_required_1000_hrs'] = val
  end

  def employer_required_vesting
    attributes['employer_required_vesting']
  end

  def employer_required_vesting=(val)
    attributes['employer_required_vesting'] = val
  end

  def employer_required_vesting_years
    attributes['employer_required_vesting_years']
  end

  def employer_required_vesting_years=(val)
    attributes['employer_required_vesting_years'] = val
  end

  def employer_discretionary
    attributes['employer_discretionary']
  end

  def employer_discretionary=(val)
    attributes['employer_discretionary'] = val
  end

  def employer_discretionary_percent
    attributes['employer_discretionary_percent']
  end

  def employer_discretionary_percent=(val)
    attributes['employer_discretionary_percent'] = val
  end

  def employer_discretionary_amtmax_applies
    attributes['employer_discretionary_amtmax_applies']
  end

  def employer_discretionary_amtmax_applies=(val)
    attributes['employer_discretionary_amtmax_applies'] = val
  end

  def employer_discretionary_amtmax_amount
    attributes['employer_discretionary_amtmax_amount']
  end

  def employer_discretionary_amtmax_amount=(val)
    attributes['employer_discretionary_amtmax_amount'] = val
  end

  def employer_discretionary_eoy
    attributes['employer_discretionary_eoy']
  end

  def employer_discretionary_eoy=(val)
    attributes['employer_discretionary_eoy'] = val
  end

  def employer_discretionary_1000_hrs
    attributes['employer_discretionary_1000_hrs']
  end

  def employer_discretionary_1000_hrs=(val)
    attributes['employer_discretionary_1000_hrs'] = val
  end

  def employer_discretionary_vesting
    attributes['employer_discretionary_vesting']
  end

  def employer_discretionary_vesting=(val)
    attributes['employer_discretionary_vesting'] = val
  end

  def employer_discretionary_years
    attributes['employer_discretionary_years']
  end

  def employer_discretionary_years=(val)
    attributes['employer_discretionary_years'] = val
  end

  def model_strategy_id
    attributes['model_strategy_id']
  end

  def model_strategy_id=(val)
    attributes['model_strategy_id'] = val
  end

  def models_number
    attributes['models_number']
  end

  def models_number=(val)
    attributes['models_number'] = val
  end

  def all_employees_defaulted_into_qdia
    attributes['all_employees_defaulted_into_qdia']
  end

  def all_employees_defaulted_into_qdia=(val)
    attributes['all_employees_defaulted_into_qdia'] = val
  end

  def auto_rebalance
    attributes['auto_rebalance']
  end

  def auto_rebalance=(val)
    attributes['auto_rebalance'] = val
  end

  def loans_allowed_general_purpose
    attributes['loans_allowed_general_purpose']
  end

  def loans_allowed_general_purpose=(val)
    attributes['loans_allowed_general_purpose'] = val
  end

  def loans_allowed_home
    attributes['loans_allowed_home']
  end

  def loans_allowed_home=(val)
    attributes['loans_allowed_home'] = val
  end

  def loans_allowed_hardship
    attributes['loans_allowed_hardship']
  end

  def loans_allowed_hardship=(val)
    attributes['loans_allowed_hardship'] = val
  end

  def max_loans
    attributes['max_loans']
  end

  def max_loans=(val)
    attributes['max_loans'] = val
  end

  def age_59_5_withdrawals
    attributes['age_59_5_withdrawals']
  end

  def age_59_5_withdrawals=(val)
    attributes['age_59_5_withdrawals'] = val
  end

  def hardship_withdrawals
    attributes['hardship_withdrawals']
  end

  def hardship_withdrawals=(val)
    attributes['hardship_withdrawals'] = val
  end

  def installment_payments
    attributes['installment_payments']
  end

  def installment_payments=(val)
    attributes['installment_payments'] = val
  end

  def annuity_option
    attributes['annuity_option']
  end

  def annuity_option=(val)
    attributes['annuity_option'] = val
  end

  def cash_out
    attributes['cash_out']
  end

  def cash_out=(val)
    attributes['cash_out'] = val
  end

  def lifetime_income_option
    attributes['lifetime_income_option']
  end

  def lifetime_income_option=(val)
    attributes['lifetime_income_option'] = val
  end

  def lifetime_income_service
    attributes['lifetime_income_service']
  end

  def lifetime_income_service=(val)
    attributes['lifetime_income_service'] = val
  end

  def valuation_frequency
    attributes['valuation_frequency']
  end

  def valuation_frequency=(val)
    attributes['valuation_frequency'] = val
  end

  def startup_startup_newlyeligible_volumes
    attributes['startup_startup_newlyeligible_volumes']
  end

  def startup_startup_newlyeligible_volumes=(val)
    attributes['startup_startup_newlyeligible_volumes'] = val
  end

  def m_and_a_volumes_acquisitions
    attributes['m_and_a_volumes_acquisitions']
  end

  def m_and_a_volumes_acquisitions=(val)
    attributes['m_and_a_volumes_acquisitions'] = val
  end

  def m_and_a_volumes_divestitures
    attributes['m_and_a_volumes_divestitures']
  end

  def m_and_a_volumes_divestitures=(val)
    attributes['m_and_a_volumes_divestitures'] = val
  end

  def ineligible_participants_volumes
    attributes['ineligible_participants_volumes']
  end

  def ineligible_participants_volumes=(val)
    attributes['ineligible_participants_volumes'] = val
  end

  def eligible_participants_volumes
    attributes['eligible_participants_volumes']
  end

  def eligible_participants_volumes=(val)
    attributes['eligible_participants_volumes'] = val
  end

  def active_participants_account_balance
    attributes['active_participants_account_balance']
  end

  def active_participants_account_balance=(val)
    attributes['active_participants_account_balance'] = val
  end

  def terminated_participants_account_balance
    attributes['terminated_participants_account_balance']
  end

  def terminated_participants_account_balance=(val)
    attributes['terminated_participants_account_balance'] = val
  end

  def participant_count
    attributes['participant_count']
  end

  def participant_count=(val)
    attributes['participant_count'] = val
  end

  def processing_payroll_volumes
    attributes['processing_payroll_volumes']
  end

  def processing_payroll_volumes=(val)
    attributes['processing_payroll_volumes'] = val
  end

  def processing_employer_match_volumes
    attributes['processing_employer_match_volumes']
  end

  def processing_employer_match_volumes=(val)
    attributes['processing_employer_match_volumes'] = val
  end

  def processing_employer_other_volumes
    attributes['processing_employer_other_volumes']
  end

  def processing_employer_other_volumes=(val)
    attributes['processing_employer_other_volumes'] = val
  end

  def deferral_rate_changes_manual
    attributes['deferral_rate_changes_manual']
  end

  def deferral_rate_changes_manual=(val)
    attributes['deferral_rate_changes_manual'] = val
  end

  def deferral_rate_changes_automated
    attributes['deferral_rate_changes_automated']
  end

  def deferral_rate_changes_automated=(val)
    attributes['deferral_rate_changes_automated'] = val
  end

  def processing_forfeiture_allocations
    attributes['processing_forfeiture_allocations']
  end

  def processing_forfeiture_allocations=(val)
    attributes['processing_forfeiture_allocations'] = val
  end

  def processing_corrected_contributions
    attributes['processing_corrected_contributions']
  end

  def processing_corrected_contributions=(val)
    attributes['processing_corrected_contributions'] = val
  end

  def processing_adp_acp_refunds
    attributes['processing_adp_acp_refunds']
  end

  def processing_adp_acp_refunds=(val)
    attributes['processing_adp_acp_refunds'] = val
  end

  def processing_adp_acp_contributions
    attributes['processing_adp_acp_contributions']
  end

  def processing_adp_acp_contributions=(val)
    attributes['processing_adp_acp_contributions'] = val
  end

  def rollover_in_volumes
    attributes['rollover_in_volumes']
  end

  def rollover_in_volumes=(val)
    attributes['rollover_in_volumes'] = val
  end

  def investment_transfer_volumes
    attributes['investment_transfer_volumes']
  end

  def investment_transfer_volumes=(val)
    attributes['investment_transfer_volumes'] = val
  end

  def loan_origination_volumes
    attributes['loan_origination_volumes']
  end

  def loan_origination_volumes=(val)
    attributes['loan_origination_volumes'] = val
  end

  def loans_maintenance_volumes
    attributes['loans_maintenance_volumes']
  end

  def loans_maintenance_volumes=(val)
    attributes['loans_maintenance_volumes'] = val
  end

  def age_59_5_volumes
    attributes['age_59_5_volumes']
  end

  def age_59_5_volumes=(val)
    attributes['age_59_5_volumes'] = val
  end

  def hardship_process_volumes
    attributes['hardship_process_volumes']
  end

  def hardship_process_volumes=(val)
    attributes['hardship_process_volumes'] = val
  end

  def mrds_volumes
    attributes['mrds_volumes']
  end

  def mrds_volumes=(val)
    attributes['mrds_volumes'] = val
  end

  def qdro_process_volumes
    attributes['qdro_process_volumes']
  end

  def qdro_process_volumes=(val)
    attributes['qdro_process_volumes'] = val
  end

  def distributions_processed_volumes
    attributes['distributions_processed_volumes']
  end

  def distributions_processed_volumes=(val)
    attributes['distributions_processed_volumes'] = val
  end

  def distributions_processed_volumes_cashout
    attributes['distributions_processed_volumes_cashout']
  end

  def distributions_processed_volumes_cashout=(val)
    attributes['distributions_processed_volumes_cashout'] = val
  end

  def fund_adds_volumes
    attributes['fund_adds_volumes']
  end

  def fund_adds_volumes=(val)
    attributes['fund_adds_volumes'] = val
  end

  def fund_deletes_volumes
    attributes['fund_deletes_volumes']
  end

  def fund_deletes_volumes=(val)
    attributes['fund_deletes_volumes'] = val
  end

  def company_stock
    attributes['company_stock']
  end

  def company_stock=(val)
    attributes['company_stock'] = val
  end

  def company_stock_dividend_allocation
    attributes['company_stock_dividend_allocation']
  end

  def company_stock_dividend_allocation=(val)
    attributes['company_stock_dividend_allocation'] = val
  end

  def company_stock_dividend_type
    attributes['company_stock_dividend_type']
  end

  def company_stock_dividend_type=(val)
    attributes['company_stock_dividend_type'] = val
  end

  def models_nav_type
    attributes['models_nav_type']
  end

  def models_nav_type=(val)
    attributes['models_nav_type'] = val
  end

  def support_annual_audit
    attributes['support_annual_audit']
  end

  def support_annual_audit=(val)
    attributes['support_annual_audit'] = val
  end

  def plan_design_changes_volumes
    attributes['plan_design_changes_volumes']
  end

  def plan_design_changes_volumes=(val)
    attributes['plan_design_changes_volumes'] = val
  end

  def implement_plan_startup_processes
    attributes['implement_plan_startup_processes']
  end

  def implement_plan_startup_processes=(val)
    attributes['implement_plan_startup_processes'] = val
  end

  def provide_plan_document_spd
    attributes['provide_plan_document_spd']
  end

  def provide_plan_document_spd=(val)
    attributes['provide_plan_document_spd'] = val
  end

  def provide_plan_document_amendments
    attributes['provide_plan_document_amendments']
  end

  def provide_plan_document_amendments=(val)
    attributes['provide_plan_document_amendments'] = val
  end

  def determine_newly_eligible_employees
    attributes['determine_newly_eligible_employees']
  end

  def determine_newly_eligible_employees=(val)
    attributes['determine_newly_eligible_employees'] = val
  end

  def send_enrollment_materials_hardcopy
    attributes['send_enrollment_materials_hardcopy']
  end

  def send_enrollment_materials_hardcopy=(val)
    attributes['send_enrollment_materials_hardcopy'] = val
  end

  def send_enrollment_materials_digital
    attributes['send_enrollment_materials_digital']
  end

  def send_enrollment_materials_digital=(val)
    attributes['send_enrollment_materials_digital'] = val
  end

  def census_validation_for_payroll
    attributes['census_validation_for_payroll']
  end

  def census_validation_for_payroll=(val)
    attributes['census_validation_for_payroll'] = val
  end

  def calculate_employer_match_volumes
    attributes['calculate_employer_match_volumes']
  end

  def calculate_employer_match_volumes=(val)
    attributes['calculate_employer_match_volumes'] = val
  end

  def calculate_employer_match_trueup
    attributes['calculate_employer_match_trueup']
  end

  def calculate_employer_match_trueup=(val)
    attributes['calculate_employer_match_trueup'] = val
  end

  def calculate_other_employer_contribution
    attributes['calculate_other_employer_contribution']
  end

  def calculate_other_employer_contribution=(val)
    attributes['calculate_other_employer_contribution'] = val
  end

  def calculate_forfeiture_allocation
    attributes['calculate_forfeiture_allocation']
  end

  def calculate_forfeiture_allocation=(val)
    attributes['calculate_forfeiture_allocation'] = val
  end

  def forfeiture_allocations_type
    attributes['forfeiture_allocations_type']
  end

  def forfeiture_allocations_type=(val)
    attributes['forfeiture_allocations_type'] = val
  end

  def distribute_required_notices_digital
    attributes['distribute_required_notices_digital']
  end

  def distribute_required_notices_digital=(val)
    attributes['distribute_required_notices_digital'] = val
  end

  def distribute_required_notices_hardcopy
    attributes['distribute_required_notices_hardcopy']
  end

  def distribute_required_notices_hardcopy=(val)
    attributes['distribute_required_notices_hardcopy'] = val
  end

  def distribute_404a5_participant_disclosures
    attributes['distribute_404a5_participant_disclosures']
  end

  def distribute_404a5_participant_disclosures=(val)
    attributes['distribute_404a5_participant_disclosures'] = val
  end

  def calculate_contribution_corrections
    attributes['calculate_contribution_corrections']
  end

  def calculate_contribution_corrections=(val)
    attributes['calculate_contribution_corrections'] = val
  end

  def rollover_in_review
    attributes['rollover_in_review']
  end

  def rollover_in_review=(val)
    attributes['rollover_in_review'] = val
  end

  def loan_origination_review
    attributes['loan_origination_review']
  end

  def loan_origination_review=(val)
    attributes['loan_origination_review'] = val
  end

  def hardship_review
    attributes['hardship_review']
  end

  def hardship_review=(val)
    attributes['hardship_review'] = val
  end

  def age_59_5_review
    attributes['age_59_5_review']
  end

  def age_59_5_review=(val)
    attributes['age_59_5_review'] = val
  end

  def mrds_review
    attributes['mrds_review']
  end

  def mrds_review=(val)
    attributes['mrds_review'] = val
  end

  def qdro_review
    attributes['qdro_review']
  end

  def qdro_review=(val)
    attributes['qdro_review'] = val
  end

  def terms_review
    attributes['terms_review']
  end

  def terms_review=(val)
    attributes['terms_review'] = val
  end

  def administer_erisa_spending_accounts
    attributes['administer_erisa_spending_accounts']
  end

  def administer_erisa_spending_accounts=(val)
    attributes['administer_erisa_spending_accounts'] = val
  end

  def erisa_spending_accounts_usage
    attributes['erisa_spending_accounts_usage']
  end

  def erisa_spending_accounts_usage=(val)
    attributes['erisa_spending_accounts_usage'] = val
  end

  def prepare_form_5500
    attributes['prepare_form_5500']
  end

  def prepare_form_5500=(val)
    attributes['prepare_form_5500'] = val
  end

  def conducts_adp_acp_testing
    attributes['conducts_adp_acp_testing']
  end

  def conducts_adp_acp_testing=(val)
    attributes['conducts_adp_acp_testing'] = val
  end

  def adp_acp_testing_type
    attributes['adp_acp_testing_type']
  end

  def adp_acp_testing_type=(val)
    attributes['adp_acp_testing_type'] = val
  end

  def calculate_adp_acp_refunds
    attributes['calculate_adp_acp_refunds']
  end

  def calculate_adp_acp_refunds=(val)
    attributes['calculate_adp_acp_refunds'] = val
  end

  def calculate_adp_acp_contributions
    attributes['calculate_adp_acp_contributions']
  end

  def calculate_adp_acp_contributions=(val)
    attributes['calculate_adp_acp_contributions'] = val
  end

  def conducts_415_testing
    attributes['conducts_415_testing']
  end

  def conducts_415_testing=(val)
    attributes['conducts_415_testing'] = val
  end

  def conducts_top_heavy_testing
    attributes['conducts_top_heavy_testing']
  end

  def conducts_top_heavy_testing=(val)
    attributes['conducts_top_heavy_testing'] = val
  end

  def calculate_top_heavy_minimum
    attributes['calculate_top_heavy_minimum']
  end

  def calculate_top_heavy_minimum=(val)
    attributes['calculate_top_heavy_minimum'] = val
  end

  def conducts_compensation_ratio_testing
    attributes['conducts_compensation_ratio_testing']
  end

  def conducts_compensation_ratio_testing=(val)
    attributes['conducts_compensation_ratio_testing'] = val
  end

  def calculates_eligible_compensation_of_self_employed
    attributes['calculates_eligible_compensation_of_self_employed']
  end

  def calculates_eligible_compensation_of_self_employed=(val)
    attributes['calculates_eligible_compensation_of_self_employed'] = val
  end

  def definition_of_compensation
    attributes['definition_of_compensation']
  end

  def definition_of_compensation=(val)
    attributes['definition_of_compensation'] = val
  end

  def meet_with_plan_committee
    attributes['meet_with_plan_committee']
  end

  def meet_with_plan_committee=(val)
    attributes['meet_with_plan_committee'] = val
  end

  def type_of_plan_committee_meetings
    attributes['type_of_plan_committee_meetings']
  end

  def type_of_plan_committee_meetings=(val)
    attributes['type_of_plan_committee_meetings'] = val
  end

  def conducts_401a4_testing
    attributes['conducts_401a4_testing']
  end

  def conducts_401a4_testing=(val)
    attributes['conducts_401a4_testing'] = val
  end

  def conducts_410b_testing
    attributes['conducts_410b_testing']
  end

  def conducts_410b_testing=(val)
    attributes['conducts_410b_testing'] = val
  end

  def monitor_section_16_insider_trading_rules
    attributes['monitor_section_16_insider_trading_rules']
  end

  def monitor_section_16_insider_trading_rules=(val)
    attributes['monitor_section_16_insider_trading_rules'] = val
  end

  def type_of_section_16_insider_trading_window
    attributes['type_of_section_16_insider_trading_window']
  end

  def type_of_section_16_insider_trading_window=(val)
    attributes['type_of_section_16_insider_trading_window'] = val
  end

  def consult_on_plan_design_changes
    attributes['consult_on_plan_design_changes']
  end

  def consult_on_plan_design_changes=(val)
    attributes['consult_on_plan_design_changes'] = val
  end

  def merger_and_acquisition_work
    attributes['merger_and_acquisition_work']
  end

  def merger_and_acquisition_work=(val)
    attributes['merger_and_acquisition_work'] = val
  end

  def assist_with_irs_and_dol_audits
    attributes['assist_with_irs_and_dol_audits']
  end

  def assist_with_irs_and_dol_audits=(val)
    attributes['assist_with_irs_and_dol_audits'] = val
  end

  def consult_on_plan_defect_correction
    attributes['consult_on_plan_defect_correction']
  end

  def consult_on_plan_defect_correction=(val)
    attributes['consult_on_plan_defect_correction'] = val
  end

  def manage_plan_transition_to_new_vendor
    attributes['manage_plan_transition_to_new_vendor']
  end

  def manage_plan_transition_to_new_vendor=(val)
    attributes['manage_plan_transition_to_new_vendor'] = val
  end

  def enrollment_kit_volumes
    attributes['enrollment_kit_volumes']
  end

  def enrollment_kit_volumes=(val)
    attributes['enrollment_kit_volumes'] = val
  end

  def mail_s_enrollment_kit_type
    attributes['mail_s_enrollment_kit_type']
  end

  def mail_s_enrollment_kit_type=(val)
    attributes['mail_s_enrollment_kit_type'] = val
  end

  def toll_free_number_recordkeepers_volumes
    attributes['toll_free_number_recordkeepers_volumes']
  end

  def toll_free_number_recordkeepers_volumes=(val)
    attributes['toll_free_number_recordkeepers_volumes'] = val
  end

  def toll_free_number_recordkeepers_type
    attributes['toll_free_number_recordkeepers_type']
  end

  def toll_free_number_recordkeepers_type=(val)
    attributes['toll_free_number_recordkeepers_type'] = val
  end

  def internet_participants_type
    attributes['internet_participants_type']
  end

  def internet_participants_type=(val)
    attributes['internet_participants_type'] = val
  end

  def hardcopy_statement_volumes
    attributes['hardcopy_statement_volumes']
  end

  def hardcopy_statement_volumes=(val)
    attributes['hardcopy_statement_volumes'] = val
  end

  def hardcopy_statement_type
    attributes['hardcopy_statement_type']
  end

  def hardcopy_statement_type=(val)
    attributes['hardcopy_statement_type'] = val
  end

  def digital_stmts_volumes
    attributes['digital_stmts_volumes']
  end

  def digital_stmts_volumes=(val)
    attributes['digital_stmts_volumes'] = val
  end

  def digital_stmts_type
    attributes['digital_stmts_type']
  end

  def digital_stmts_type=(val)
    attributes['digital_stmts_type'] = val
  end

  def retirement_projection_hardcopy_statement_volumes
    attributes['retirement_projection_hardcopy_statement_volumes']
  end

  def retirement_projection_hardcopy_statement_volumes=(val)
    attributes['retirement_projection_hardcopy_statement_volumes'] = val
  end

  def retirement_projection_hardcopy_statement_type
    attributes['retirement_projection_hardcopy_statement_type']
  end

  def retirement_projection_hardcopy_statement_type=(val)
    attributes['retirement_projection_hardcopy_statement_type'] = val
  end

  def retirement_projection_digital_statement_volumes
    attributes['retirement_projection_digital_statement_volumes']
  end

  def retirement_projection_digital_statement_volumes=(val)
    attributes['retirement_projection_digital_statement_volumes'] = val
  end

  def retirement_projection_digital_statement_type
    attributes['retirement_projection_digital_statement_type']
  end

  def retirement_projection_digital_statement_type=(val)
    attributes['retirement_projection_digital_statement_type'] = val
  end

  def hardcopy_plan_driven_events
    attributes['hardcopy_plan_driven_events']
  end

  def hardcopy_plan_driven_events=(val)
    attributes['hardcopy_plan_driven_events'] = val
  end

  def hardcopy_plan_driven_events_type
    attributes['hardcopy_plan_driven_events_type']
  end

  def hardcopy_plan_driven_events_type=(val)
    attributes['hardcopy_plan_driven_events_type'] = val
  end

  def digital_plan_driven_events
    attributes['digital_plan_driven_events']
  end

  def digital_plan_driven_events=(val)
    attributes['digital_plan_driven_events'] = val
  end

  def digital_plan_driven_events_type
    attributes['digital_plan_driven_events_type']
  end

  def digital_plan_driven_events_type=(val)
    attributes['digital_plan_driven_events_type'] = val
  end

  def hardcopy_campaigns
    attributes['hardcopy_campaigns']
  end

  def hardcopy_campaigns=(val)
    attributes['hardcopy_campaigns'] = val
  end

  def hardcopy_campaign_type
    attributes['hardcopy_campaign_type']
  end

  def hardcopy_campaign_type=(val)
    attributes['hardcopy_campaign_type'] = val
  end

  def digital_campaigns
    attributes['digital_campaigns']
  end

  def digital_campaigns=(val)
    attributes['digital_campaigns'] = val
  end

  def digital_campaign_type
    attributes['digital_campaign_type']
  end

  def digital_campaign_type=(val)
    attributes['digital_campaign_type'] = val
  end

  def group_meetings
    attributes['group_meetings']
  end

  def group_meetings=(val)
    attributes['group_meetings'] = val
  end

  def group_meetings_type
    attributes['group_meetings_type']
  end

  def group_meetings_type=(val)
    attributes['group_meetings_type'] = val
  end

  def one_on_one_meetings
    attributes['one_on_one_meetings']
  end

  def one_on_one_meetings=(val)
    attributes['one_on_one_meetings'] = val
  end

  def one_on_one_meetings_type
    attributes['one_on_one_meetings_type']
  end

  def one_on_one_meetings_type=(val)
    attributes['one_on_one_meetings_type'] = val
  end

  def participation_pre_tax_rate_overall
    attributes['participation_pre_tax_rate_overall']
  end

  def participation_pre_tax_rate_overall=(val)
    attributes['participation_pre_tax_rate_overall'] = val
  end

  def participation_pre_tax_rate_hces
    attributes['participation_pre_tax_rate_hces']
  end

  def participation_pre_tax_rate_hces=(val)
    attributes['participation_pre_tax_rate_hces'] = val
  end

  def participation_pre_tax_rate_nhces
    attributes['participation_pre_tax_rate_nhces']
  end

  def participation_pre_tax_rate_nhces=(val)
    attributes['participation_pre_tax_rate_nhces'] = val
  end

  def pre_tax_deferral_percent_overall
    attributes['pre_tax_deferral_percent_overall']
  end

  def pre_tax_deferral_percent_overall=(val)
    attributes['pre_tax_deferral_percent_overall'] = val
  end

  def pre_tax_deferral_percent_hces
    attributes['pre_tax_deferral_percent_hces']
  end

  def pre_tax_deferral_percent_hces=(val)
    attributes['pre_tax_deferral_percent_hces'] = val
  end

  def pre_tax_deferral_percent_nhces
    attributes['pre_tax_deferral_percent_nhces']
  end

  def pre_tax_deferral_percent_nhces=(val)
    attributes['pre_tax_deferral_percent_nhces'] = val
  end

  def participation_roth_rate_overall
    attributes['participation_roth_rate_overall']
  end

  def participation_roth_rate_overall=(val)
    attributes['participation_roth_rate_overall'] = val
  end

  def participation_roth_rate_hces
    attributes['participation_roth_rate_hces']
  end

  def participation_roth_rate_hces=(val)
    attributes['participation_roth_rate_hces'] = val
  end

  def participation_roth_rate_nhces
    attributes['participation_roth_rate_nhces']
  end

  def participation_roth_rate_nhces=(val)
    attributes['participation_roth_rate_nhces'] = val
  end

  def roth_deferral_percent_overall
    attributes['roth_deferral_percent_overall']
  end

  def roth_deferral_percent_overall=(val)
    attributes['roth_deferral_percent_overall'] = val
  end

  def roth_deferral_percent_hces
    attributes['roth_deferral_percent_hces']
  end

  def roth_deferral_percent_hces=(val)
    attributes['roth_deferral_percent_hces'] = val
  end

  def roth_deferral_percent_nhces
    attributes['roth_deferral_percent_nhces']
  end

  def roth_deferral_percent_nhces=(val)
    attributes['roth_deferral_percent_nhces'] = val
  end

  def auto_escalate_percent_parts
    attributes['auto_escalate_percent_parts']
  end

  def auto_escalate_percent_parts=(val)
    attributes['auto_escalate_percent_parts'] = val
  end

  def auto_escalate_avg_increase
    attributes['auto_escalate_avg_increase']
  end

  def auto_escalate_avg_increase=(val)
    attributes['auto_escalate_avg_increase'] = val
  end

  def max_company_match_percent_parts
    attributes['max_company_match_percent_parts']
  end

  def max_company_match_percent_parts=(val)
    attributes['max_company_match_percent_parts'] = val
  end

  def catchup_percent_parts
    attributes['catchup_percent_parts']
  end

  def catchup_percent_parts=(val)
    attributes['catchup_percent_parts'] = val
  end

  def dollars_in_models
    attributes['dollars_in_models']
  end

  def dollars_in_models=(val)
    attributes['dollars_in_models'] = val
  end

  def terms_volumes
    attributes['terms_volumes']
  end

  def terms_volumes=(val)
    attributes['terms_volumes'] = val
  end

  def terms_still_in_plan_percent_parts_12mos
    attributes['terms_still_in_plan_percent_parts_12mos']
  end

  def terms_still_in_plan_percent_parts_12mos=(val)
    attributes['terms_still_in_plan_percent_parts_12mos'] = val
  end

  def terms_rolled_over_percent_parts_12mos
    attributes['terms_rolled_over_percent_parts_12mos']
  end

  def terms_rolled_over_percent_parts_12mos=(val)
    attributes['terms_rolled_over_percent_parts_12mos'] = val
  end

  def terms_cashed_out_percent_parts_12mos
    attributes['terms_cashed_out_percent_parts_12mos']
  end

  def terms_cashed_out_percent_parts_12mos=(val)
    attributes['terms_cashed_out_percent_parts_12mos'] = val
  end

  def terms_still_in_plan_amt_12mos
    attributes['terms_still_in_plan_amt_12mos']
  end

  def terms_still_in_plan_amt_12mos=(val)
    attributes['terms_still_in_plan_amt_12mos'] = val
  end

  def terms_rolled_over_amt_12mos
    attributes['terms_rolled_over_amt_12mos']
  end

  def terms_rolled_over_amt_12mos=(val)
    attributes['terms_rolled_over_amt_12mos'] = val
  end

  def terms_cashed_out_amt_12mos
    attributes['terms_cashed_out_amt_12mos']
  end

  def terms_cashed_out_amt_12mos=(val)
    attributes['terms_cashed_out_amt_12mos'] = val
  end

  def advisor_twelve_b1_fees_broker_of_record
    attributes['advisor_twelve_b1_fees_broker_of_record']
  end

  def advisor_twelve_b1_fees_broker_of_record=(val)
    attributes['advisor_twelve_b1_fees_broker_of_record'] = val
  end

  def advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions
    attributes['advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions']
  end

  def advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions=(val)
    attributes['advisor_twelve_b1_how_dispensed_picklist_feesdispensedoptions'] = val
  end

  def participation_pre_tax_deferral_percent_hces
    attributes['participation_pre_tax_deferral_percent_hces']
  end

  def participation_pre_tax_deferral_percent_hces=(val)
    attributes['participation_pre_tax_deferral_percent_hces'] = val
  end

  def participation_pre_tax_deferral_percent_nhces
    attributes['participation_pre_tax_deferral_percent_nhces']
  end

  def participation_pre_tax_deferral_percent_nhces=(val)
    attributes['participation_pre_tax_deferral_percent_nhces'] = val
  end

  def created_at
    attributes['created_at']
  end

  def created_at=(val)
    attributes['created_at'] = val
  end

  def updated_at
    attributes['updated_at']
  end

  def updated_at=(val)
    attributes['updated_at'] = val
  end

  def company_id_recordkeeper
    attributes['company_id_recordkeeper']
  end

  def company_id_recordkeeper=(val)
    attributes['company_id_recordkeeper'] = val
  end

  def company_id_tpa
    attributes['company_id_tpa']
  end

  def company_id_tpa=(val)
    attributes['company_id_tpa'] = val
  end

  def company_id_advisor_firm
    attributes['company_id_advisor_firm']
  end

  def company_id_advisor_firm=(val)
    attributes['company_id_advisor_firm'] = val
  end

  def person_id_advisor
    attributes['person_id_advisor']
  end

  def person_id_advisor=(val)
    attributes['person_id_advisor'] = val
  end

  def advisor_makes_payments_to_providers
    attributes['advisor_makes_payments_to_providers']
  end

  def advisor_makes_payments_to_providers=(val)
    attributes['advisor_makes_payments_to_providers'] = val
  end

  def advisor_credits_plan_or_participants
    attributes['advisor_credits_plan_or_participants']
  end

  def advisor_credits_plan_or_participants=(val)
    attributes['advisor_credits_plan_or_participants'] = val
  end

  def service_group_id
    attributes['service_group_id']
  end

  def service_group_id=(val)
    attributes['service_group_id'] = val
  end






  def self.mock_instance_methods
    return @mock_instance_methods if @mock_instance_methods
    @mock_instance_methods = {}
    @mock_instance_methods[:bar] = :not_implemented
    
    @mock_instance_methods[:baz] = :not_implemented
     @mock_instance_methods
  end

  def self.mock_class_methods
    return @mock_class_methods if @mock_class_methods
    @mock_class_methods = {} @mock_class_methods
  end


  def bar(name, type=nil)
    block =  mock_instance_methods[:bar]
    raise %Q[#bar  is not Implemented for Class: PlanMock] if block.class == Symbol
    instance_exec(*[name, type], &block)
  end

  def baz()
    block =  mock_instance_methods[:baz]
    raise %Q[#baz  is not Implemented for Class: PlanMock] if block.class == Symbol
    instance_exec(*[], &block)
  end




end