require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)

require 'active_mocker/table'
require 'active_mocker/field'
require 'active_mocker/active_record/schema'
require 'active_mocker/model_reader'

describe ActiveMocker::ActiveRecord::Schema do

  after do
    described_class.clear_cache
  end


  it 'run' do

    described_class.search('advisor_fee_groups')

    result = described_class.define(version: 1) do

      create_table "advisor_fee_groups", force: true do |t|
        t.integer "service_fee_id_legacy"
        t.integer "plan_id",                      limit: 8
        t.string  "name",                         limit: 64
        t.string  "description",                  limit: 256
        t.boolean "effective_immediately",        precision: 23
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
        t.integer "plan_tiered_fees_template_id"
      end

      create_table "advisor_fee", force: true do |t|
        t.integer "service_fee_id_legacy"
        t.integer "plan_id",                      limit: 8
        t.string  "name",                         limit: 64
        t.string  "description",                  limit: 256
        t.boolean "effective_immediately"
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
        t.integer "plan_tiered_fees_template_id"
      end

      add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

    end

    expect(result.name).to eq('advisor_fee_groups')
    expect(described_class.search_cache('advisor_fee_groups').name).to eq 'advisor_fee_groups'


  end

  it 'does not break' do

    described_class.search('rating_agencies')

    result = described_class.define(version: 20140327205359) do

      create_table "admin_users", force: true do |t|
        t.string   "email",                  default: "", null: false
        t.string   "encrypted_password",     default: "", null: false
        t.string   "reset_password_token"
        t.datetime "reset_password_sent_at"
        t.datetime "remember_created_at"
        t.integer  "sign_in_count",          default: 0,  null: false
        t.datetime "current_sign_in_at"
        t.datetime "last_sign_in_at"
        t.string   "current_sign_in_ip"
        t.string   "last_sign_in_ip"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
      add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

      create_table "advisor_additonal_data", force: true do |t|
        t.integer "user_id"
        t.integer "finra_advisor_id"
        t.integer "bd_ria_organization_advisor_id"
        t.boolean "principal"
        t.boolean "osj_status"
        t.string  "osj_email",                                          limit: 150
        t.integer "form_adv_locator"
        t.string  "website",                                            limit: 150
        t.string  "team_name",                                          limit: 150
        t.boolean "advisor_psm_on_summary_page"
        t.decimal "rank_factor_investments",                                        precision: 7, scale: 4
        t.decimal "rank_factor_vendor_mgmt",                                        precision: 7, scale: 4
        t.decimal "rank_factor_plan_mgmt",                                          precision: 7, scale: 4
        t.decimal "rank_factor_part_services",                                      precision: 7, scale: 4
        t.date    "disclosure_408_b_2_subscription_date"
        t.date    "dc_benchmarking_subscription_date"
        t.date    "disclosure_403b_457_benchmarking_subscription_date"
        t.date    "db_benchmarking_subscription_date"
        t.date    "retirement_outcomes_evaluation_subscription_date"
        t.date    "plan_profile_subscription_date"
        t.date    "provider_5500_subscription_date"
        t.date    "disclosure_408_b_2_expiration_date"
        t.date    "dc_benchmarking_expiration_date"
        t.date    "disclosure_403b_457_benchmarking_expiration_date"
        t.date    "db_benchmarking_expiration_date"
        t.date    "retirement_outcomes_evaluation_expiration_date"
        t.date    "plan_profile_expiration_date"
        t.date    "provider_5500_expiration_date"
      end

      create_table "advisor_additonal_data_principal_exams", id: false, force: true do |t|
        t.integer "AdvisorAdditonalDatum_id"
        t.integer "PrincipalExam_id"
      end

      create_table "advisor_additonal_data_reg_rep_exams", id: false, force: true do |t|
        t.integer "AdvisorAdditonalDatum_id"
        t.integer "RegRepExam_id"
      end

      create_table "advisor_fee_groups", force: true do |t|
        t.integer "service_fee_id_legacy"
        t.integer "plan_id"
        t.string  "name",                         limit: 64
        t.string  "description",                  limit: 256
        t.boolean "effective_immediately"
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
        t.integer "plan_tiered_fees_template_id"
      end

      create_table "advisor_fee_single_templates", force: true do |t|
        t.integer "advisor_fee_template_id"
        t.integer "advisor_service_separate_fees_template_id"
        t.integer "service_master_id"
        t.integer "fee_type_id"
        t.decimal "amount_percent",                                        precision: 7, scale: 4
        t.integer "amount_dollar"
        t.integer "annual_hours"
        t.integer "timing_type_id"
        t.integer "payment_term_id"
        t.string  "payor",                                     limit: 128
        t.integer "payor_type_id"
      end

      create_table "advisor_fee_singles", force: true do |t|
        t.integer "advisor_fee_group_id"
        t.integer "advisor_service_separate_fee_group_id"
        t.integer "advisor_service_single_id"
        t.integer "fee_type_id"
        t.decimal "amount_percent",                                    precision: 7, scale: 4
        t.integer "amount_dollar"
        t.integer "annual_hours"
        t.integer "timing_type_id"
        t.integer "payment_term_id"
        t.string  "payor",                                 limit: 128
        t.integer "payor_type_id"
      end

      create_table "advisor_fee_templates", force: true do |t|
        t.integer "advisor_template_id_legacy"
        t.integer "user_id"
        t.string  "name",                       limit: 100
        t.string  "description",                limit: 500
        t.boolean "effective_immediately"
        t.boolean "delayed_effective_date"
        t.date    "effective_date"
      end

      create_table "advisor_fee_tier_set_templates", force: true do |t|
        t.integer "advisor_fees_template_id"
        t.string  "name",                     limit: 63
        t.string  "description"
      end

      create_table "advisor_fee_tier_sets", force: true do |t|
        t.integer "plan_id"
        t.integer "advisor_fee_tier_set_template_id"
        t.string  "name",                             limit: 64
        t.string  "description",                      limit: 64
      end

      create_table "advisor_fee_tier_templates", force: true do |t|
        t.integer "advisor_fee_tier_set_template_id"
        t.integer "index"
        t.integer "range_top"
        t.decimal "fee_percent",                      precision: 5, scale: 2
        t.integer "fee_amount"
      end

      create_table "advisor_fee_tiers", force: true do |t|
        t.integer "advisor_fee_tier_set_id"
        t.integer "index"
        t.integer "range_top"
        t.decimal "fee_percent",             precision: 5, scale: 2
        t.integer "fee_amount"
      end

      create_table "advisor_product_guides", force: true do |t|
        t.integer "plan_id"
        t.integer "rk_tpa_list_id"
        t.string  "product_guide_name",                limit: 100
        t.string  "product_guide_description",         limit: 500
        t.integer "user_advisor_svc_template_id"
        t.integer "user_advisor_svc_separate_fees_id"
        t.integer "user_advisor_fee_template_id"
        t.integer "user_tiered_fees_template_id"
        t.integer "user_advisor_solicitor_fees_id"
      end

      create_table "advisor_service_groups", force: true do |t|
        t.integer "service_fees_id_legacy"
        t.integer "plan_id"
        t.integer "user_id"
        t.string  "name",                                  limit: 100
        t.string  "description",                           limit: 500
        t.integer "plan_advisor_service_separate_fees_id"
        t.integer "fiduciary_status_plan"
        t.integer "fiduciary_status_models"
        t.integer "fiduciary_status_participants"
      end

      create_table "advisor_service_sep_fee_groups", force: true do |t|
        t.integer "plan_id"
        t.integer "advisor_service_separate_fees_template_id"
        t.string  "name",                                      limit: 64
        t.string  "description",                               limit: 64
      end

      create_table "advisor_service_separate_fees_templates", force: true do |t|
        t.integer "user_id"
        t.string  "name",        limit: 64
        t.string  "description", limit: 64
      end

      create_table "advisor_solicitor_fee_templates", force: true do |t|
        t.integer "user_id"
        t.string  "name",                 limit: 64
        t.string  "description",          limit: 64
        t.string  "provider_description", limit: 64
        t.integer "interval_id"
        t.string  "solicitor_fee_timing", limit: 64
        t.integer "payor_type_id"
        t.integer "amount_dollar"
        t.decimal "amount_bps",                      precision: 7, scale: 4
      end

      create_table "advisor_solicitor_fees", force: true do |t|
        t.integer "plan_id"
        t.string  "name",                 limit: 64
        t.string  "description",          limit: 64
        t.string  "provider_description", limit: 64
        t.integer "interval_id"
        t.string  "solicitor_fee_timing", limit: 64
        t.integer "payor_type_id"
        t.integer "amount_dollar"
        t.decimal "amount_bps",                      precision: 7, scale: 4
      end

      create_table "alder_frequency_types", force: true do |t|
        t.string "name"
      end

      create_table "alder_plans", force: true do |t|
        t.integer "user_id"
        t.integer "participants_count"
        t.string  "name"
      end

      create_table "annuity_rates", force: true do |t|
        t.decimal "annuity_conversion_rate_per_1000",             precision: 8, scale: 2
        t.string  "insurance_company_name",           limit: 100
        t.date    "quarter_end"
      end

      create_table "bd_ria_clients", force: true do |t|
        t.integer "client_id"
        t.decimal "rank_factor_investments",                             precision: 7, scale: 4
        t.decimal "rank_factor_vendor_mgmt",                             precision: 7, scale: 4
        t.decimal "rank_factor_plan_mgmt",                               precision: 7, scale: 4
        t.decimal "rank_factor_part_services",                           precision: 7, scale: 4
        t.boolean "is_advisor_psm_on_summary_page"
        t.boolean "is_allow_psm_override_by_advisor"
        t.integer "408b2_bd_brokerage_fees_chart_location"
        t.integer "408b2_bd_brokerage_fees_for_services_chart_location"
        t.decimal "408b2_bd_minimum_payout_percentages",                 precision: 7, scale: 4
        t.decimal "408b2_bd_maximum_payout_percentages",                 precision: 7, scale: 4
      end

      create_table "bd_ria_product_guides", force: true do |t|
        t.integer "client_id"
        t.string  "name",        limit: 30
        t.string  "description", limit: 150
      end

      create_table "benchmark_reports", force: true do |t|
        t.integer "report_id"
        t.integer "payor_profile_id_future"
        t.boolean "v2_investments_chapter"
        t.boolean "v2_recordkeeper_chapter"
        t.boolean "v2_tpa_chapter"
        t.boolean "v2_advisor_chapter"
        t.boolean "v2_retirement_readiness_chapter"
        t.boolean "2_pager_recordkeeper_chapter"
        t.boolean "2_pager_tpa_chapter"
        t.boolean "2_pager_advisor_chapter"
        t.boolean "plan_profile"
        t.integer "report_creation_type_id"
        t.date    "report_initiated_date"
        t.date    "desired_report_delivery_date"
        t.date    "targeted_report_delivery_date"
        t.date    "actual_report_completion_date"
        t.date    "actual_report_delivery_date"
        t.date    "actual_report_download_date"
        t.integer "report_location"
        t.string  "investment_data_status",                                       limit: 10
        t.string  "stable_value_data_status",                                     limit: 10
        t.string  "general_account_data_status",                                  limit: 10
        t.string  "plan_other_fees_status",                                       limit: 10
        t.string  "participant_activity_fees_status",                             limit: 10
        t.string  "managed_account_fees_status",                                  limit: 10
        t.string  "self_directed_fees_status",                                    limit: 10
        t.string  "plan_complexity_status",                                       limit: 10
        t.string  "participant_success_measures_status",                          limit: 10
        t.string  "recordkeeper_services_status",                                 limit: 10
        t.string  "tpa_services_status",                                          limit: 10
        t.string  "advisor_services_status",                                      limit: 10
        t.string  "cover_page_status",                                            limit: 10
        t.integer "investment_data_status_last_edit_user_id_future"
        t.integer "stable_value_data_status_last_edit_user_id_future"
        t.integer "general_account_data_status_last_edit_user_id_future"
        t.integer "plan_other_fees_status_last_edit_user_id_future"
        t.integer "participant_activity_fees_status_last_edit_user_id_future"
        t.integer "managed_account_fees_status_last_edit_user_id_future"
        t.integer "self_directed_fees_status_last_edit_user_id_future"
        t.integer "plan_complexity_status_last_edit_user_id_future"
        t.integer "participant_success_measures_status_last_edit_user_id_future"
        t.integer "recordkeeper_services_status_last_edit_user_id_future"
        t.integer "tpa_services_status_last_edit_user_id_future"
        t.integer "advisor_services_status_last_edit_user_id_future"
        t.integer "cover_page_status_last_edit_user_id_future"
        t.date    "investment_data_status_last_edit_date"
        t.date    "stable_value_data_status_last_edit_date"
        t.date    "general_account_data_status_last_edit_date"
        t.date    "plan_other_fees_status_last_edit_date"
        t.date    "participant_activity_fees_status_last_edit_date"
        t.date    "managed_account_fees_status_last_edit_date"
        t.date    "self_directed_fees_status_last_edit_date"
        t.date    "plan_complexity_status_last_edit_date"
        t.date    "participant_success_measures_status_last_edit_date"
        t.date    "recordkeeper_services_status_last_edit_date"
        t.date    "tpa_services_status_last_edit_date"
        t.date    "advisor_services_status_last_edit_date"
        t.date    "cover_page_status_last_edit_date"
        t.integer "report_status_id"
        t.text    "report_notes"
        t.date    "report_data_set_date"
        t.integer "report_data_set_string"
        t.text    "report_data_set_notes"
        t.integer "billing_amount"
        t.integer "billing_status"
        t.integer "inv_benchmark_group_id"
        t.date    "inv_benchmark_group_id_date"
        t.integer "rk_benchmark_group_id"
        t.date    "rk_benchmark_group_id_date"
        t.integer "tpa_benchmark_group_id"
        t.date    "tpa_benchmark_group_id_date"
        t.integer "advisor_benchmark_group_id"
        t.date    "advisor_benchmark_group_id_date"
        t.integer "plan_complexity_fees_benchmark_group_id"
        t.date    "plan_complexity_fees_benchmark_group_id_date"
        t.integer "naics_2_digit_plan_complexity_benchmark_group_id"
        t.date    "naics_2_digit_plan_complexity_benchmark_group_date"
        t.integer "naics_3_digit_plan_complexity_benchmark_group_id"
        t.date    "naics_3_digit_plan_complexity_benchmark_group_date"
        t.integer "naics_2_digit_part_success_metrics_benchmark_group_id"
        t.date    "naics_2_digit_part_success_metrics_benchmark_group_date"
        t.integer "naics_3_digit_part_success_metrics_benchmark_group_id"
        t.date    "naics_3_digit_part_success_metrics_benchmark_group_date"
        t.integer "naics_2_digit_employer_contribution_benchmark_group_id"
        t.date    "naics_2_digit_employer_contribution_benchmark_group_date"
        t.integer "naics_3_digit_employer_contribution_benchmark_group_id"
        t.date    "naics_3_digit_employer_contribution_benchmark_group_date"
        t.integer "rk_feedback_question_1"
        t.integer "rk_feedback_question_2"
        t.integer "rk_feedback_question_3"
        t.integer "rk_feedback_question_4"
        t.date    "rk_feedback_question_5"
        t.decimal "rk_feedback_question_6",                                                  precision: 5, scale: 2
        t.decimal "rk_feedback_question_7",                                                  precision: 5, scale: 2
        t.integer "rk_feedback_question_8"
        t.integer "rk_feedback_question_9"
        t.integer "rk_feedback_question_10"
        t.integer "rk_feedback_question_11"
        t.integer "tpa_feedback_question_1"
        t.integer "tpa_feedback_question_2"
        t.integer "tpa_feedback_question_3"
        t.integer "tpa_feedback_question_4"
        t.date    "tpa_feedback_question_5"
        t.decimal "tpa_feedback_question_6",                                                 precision: 5, scale: 2
        t.integer "tpa_feedback_question_8"
        t.integer "tpa_feedback_question_9"
        t.integer "tpa_feedback_question_10"
        t.integer "tpa_feedback_question_11"
        t.integer "advisor_feedback_question_1"
        t.integer "advisor_feedback_question_2"
        t.integer "advisor_feedback_question_3"
        t.integer "advisor_feedback_question_4"
        t.integer "advisor_feedback_question_5"
        t.date    "advisor_feedback_question_6"
        t.integer "advisor_feedback_question_7"
        t.integer "advisor_feedback_question_8"
        t.integer "advisor_feedback_question_9"
        t.integer "advisor_feedback_question_10"
        t.integer "advisor_feedback_question_11"
        t.integer "dcio_feedback_question_1"
        t.integer "dcio_feedback_question_2"
        t.integer "dcio_feedback_question_3"
        t.integer "dcio_feedback_question_4"
        t.integer "dcio_feedback_question_5"
        t.integer "plan_sponsor_feedback_question_2"
        t.integer "plan_sponsor_feedback_question_3"
        t.integer "plan_sponsor_feedback_question_4"
        t.integer "plan_sponsor_feedback_question_5"
        t.date    "plan_sponsor_feedback_question_6"
        t.integer "plan_sponsor_feedback_question_8"
        t.integer "plan_sponsor_feedback_question_9"
        t.integer "plan_sponsor_feedback_question_10"
        t.integer "plan_sponsor_feedback_question_11"
      end

      create_table "bmg_advisor_investment_fees", force: true do |t|
        t.integer "market_segment_id"
        t.integer "fbi_asset_class_id"
        t.integer "investment_strategy_id"
        t.decimal "to_advisor_25th",        precision: 8, scale: 5
        t.decimal "to_advisor_50th",        precision: 8, scale: 5
        t.decimal "to_advisor_75th",        precision: 8, scale: 5
      end

      create_table "bmg_advisor_masters", force: true do |t|
        t.date    "vintage_date"
        t.integer "advisor_bmg_assets_low"
        t.integer "advisor_bmg_assets_50th"
        t.integer "advisor_bmg_assets_high"
        t.decimal "advisor_bmg_correlation_coefficient",       precision: 6,  scale: 3
        t.decimal "advisor_bmg_regressionline_slope_value",    precision: 8,  scale: 5
        t.decimal "advisor_bmg_regressionline_constant_value", precision: 7,  scale: 2
        t.integer "advisor_total_plans"
        t.integer "advisor_planstype_401k"
        t.integer "advisor_planstype_403b"
        t.integer "advisor_planstype_other"
        t.integer "advisor_plans_insco"
        t.integer "advisor_plans_mutualfunds"
        t.integer "advisor_plans_bank"
        t.integer "advisor_plans_tpa"
        t.integer "advisor_plans_other"
        t.integer "advisor_total_rks"
        t.integer "advisor_rkbusinessmodel_insco"
        t.integer "advisor_rkbusinessmodel_mutualfunds"
        t.integer "advisor_rkbusinessmodel_bank"
        t.integer "advisor_rkbusinessmodel_tpa"
        t.integer "advisor_rkbusinessmodel_other"
        t.decimal "advisor_totalfees_amt_5th",                 precision: 12, scale: 2
        t.decimal "advisor_totalfees_amt_25th",                precision: 12, scale: 2
        t.decimal "advisor_totalfees_amt_50th",                precision: 12, scale: 2
        t.decimal "advisor_totalfees_amt_75th",                precision: 12, scale: 2
        t.decimal "advisor_totalfees_amt_95th",                precision: 12, scale: 2
        t.decimal "advisor_totalfees_bps_5th",                 precision: 7,  scale: 4
        t.decimal "advisor_totalfees_bps_25th",                precision: 7,  scale: 4
        t.decimal "advisor_totalfees_bps_50th",                precision: 7,  scale: 4
        t.decimal "advisor_totalfees_bps_75th",                precision: 7,  scale: 4
        t.decimal "advisor_totalfees_bps_95th",                precision: 7,  scale: 4
      end

      create_table "bmg_advisor_plans", force: true do |t|
        t.integer "bmg_advisor_master_id"
        t.date    "vintage_date"
        t.integer "plan_id"
        t.integer "total_participants"
        t.integer "total_assets"
        t.integer "average_balance"
        t.integer "total_advisor_fees"
        t.integer "total_advisor_fees_per_participant"
      end

      create_table "bmg_contribution_match_tiers", force: true do |t|
        t.integer "bmg_employer_contribution_id"
        t.integer "tier_group"
        t.integer "tier_number"
        t.decimal "range_top",                    precision: 5, scale: 2
        t.decimal "ceiling",                      precision: 5, scale: 2
        t.decimal "value",                        precision: 5, scale: 2
      end

      create_table "bmg_contribution_types", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "bmg_employer_contributions", force: true do |t|
        t.date    "vintage_date"
        t.integer "naics_2_digit_code_id"
        t.integer "naics_3_digit_code_id"
        t.decimal "employer_match_percent_plans_no_match",                          precision: 5, scale: 2
        t.decimal "employer_match_percent_plans_formula_fixed",                     precision: 5, scale: 2
        t.decimal "employer_match_percent_plans_formula_discretionary",             precision: 5, scale: 2
        t.decimal "employer_match_percent_plans_formula_single_tier",               precision: 5, scale: 2
        t.decimal "employer_match_percent_plans_formula_multi_tier_safe_harbor",    precision: 5, scale: 2
        t.decimal "employer_match_percent_plans_formula_multi_tier_other",          precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_with_contribution_no",           precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_with_contribution_yes",          precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_formula_straight_percent_qnec",  precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_formula_straight_percent_other", precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_formula_integrated",             precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_formula_points_based",           precision: 5, scale: 2
        t.decimal "employer_required_percent_plans_formula_other",                  precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_with_contribution_no",      precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_with_contribution_yes",     precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_formula_straight_percent",  precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_formula_integrated",        precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_formula_points_based",      precision: 5, scale: 2
        t.decimal "employer_discretionary_percent_plans_formula_other",             precision: 5, scale: 2
        t.decimal "employer_total_contribution_as_percent_5th",                     precision: 7, scale: 4
        t.decimal "employer_total_contribution_as_percent_25th",                    precision: 7, scale: 4
        t.decimal "employer_total_contribution_as_percent_50th",                    precision: 7, scale: 4
        t.decimal "employer_total_contribution_as_percent_75th",                    precision: 7, scale: 4
        t.decimal "employer_total_contribution_as_percent_95th",                    precision: 7, scale: 4
      end

      create_table "bmg_inv_investment_fee_groups", force: true do |t|
        t.integer "market_segment_id"
        t.integer "fbi_asset_class_id"
        t.decimal "percent_not_paying_revenue_share", precision: 8, scale: 5
        t.decimal "percent_paying_revenue_share",     precision: 8, scale: 5
        t.decimal "percent_of_plans_with_category",   precision: 8, scale: 5
      end

      create_table "bmg_inv_investment_fees", force: true do |t|
        t.integer "market_segment_id"
        t.integer "fbi_asset_class_id"
        t.integer "investment_strategy_id"
        t.boolean "is_revenue_sharing"
        t.decimal "to_inv_25th",            precision: 8, scale: 5
        t.decimal "to_inv_50th",            precision: 8, scale: 5
        t.decimal "to_inv_75th",            precision: 8, scale: 5
      end

      create_table "bmg_inv_masters", force: true do |t|
        t.date    "vintage_date"
        t.integer "inv_bmg_assets_low"
        t.integer "inv_bmg_assets_50th"
        t.integer "inv_bmg_assets_high"
        t.integer "inv_total_plans"
        t.integer "inv_planstype_401k"
        t.integer "inv_planstype_403b"
        t.integer "inv_planstype_other"
        t.integer "inv_plans_insco"
        t.integer "inv_plans_mutualfunds"
        t.integer "inv_plans_bank"
        t.integer "inv_plans_tpa"
        t.integer "inv_plans_other"
        t.integer "inv_total_rks"
        t.integer "inv_rkbusinessmodel_insco"
        t.integer "inv_rkbusinessmodel_mutualfunds"
        t.integer "inv_rkbusinessmodel_bank"
        t.integer "inv_rkbusinessmodel_tpa"
        t.integer "inv_rkbusinessmodel_other"
        t.decimal "invoffering_targetretirementdatefunds_percentoffering",     precision: 5, scale: 2
        t.decimal "invoffering_targetretirementdatefunds_percentactive",       precision: 5, scale: 2
        t.decimal "invoffering_targetretirementdatefunds_percentpassive",      precision: 5, scale: 2
        t.decimal "invoffering_riskbased_percentoffering",                     precision: 5, scale: 2
        t.decimal "invoffering_riskbased_percentactive",                       precision: 5, scale: 2
        t.decimal "invoffering_riskbased_percentpassive",                      precision: 5, scale: 2
        t.decimal "invoffering_coremodeltrgtdate_percentoffering",             precision: 5, scale: 2
        t.decimal "invoffering_coremodelriskbased_percentoffering",            precision: 5, scale: 2
        t.decimal "invoffering_managedaccountprogram_percentoffering",         precision: 5, scale: 2
        t.decimal "invoffering_generalaccountfixed_percentoffering",           precision: 5, scale: 2
        t.decimal "invoffering_stablevalue_percentoffering",                   precision: 5, scale: 2
        t.decimal "invoffering_stablevalue_percentactive",                     precision: 5, scale: 2
        t.decimal "invoffering_stablevalue_percentpassive",                    precision: 5, scale: 2
        t.decimal "invoffering_moneymarket_percentoffering",                   precision: 5, scale: 2
        t.decimal "invoffering_moneymarket_percentactive",                     precision: 5, scale: 2
        t.decimal "invoffering_moneymarket_percentpassive",                    precision: 5, scale: 2
        t.decimal "invoffering_fixedincome_percentoffering",                   precision: 5, scale: 2
        t.decimal "invoffering_fixedincome_percentactive",                     precision: 5, scale: 2
        t.decimal "invoffering_fixedincome_percentpassive",                    precision: 5, scale: 2
        t.decimal "invoffering_highyield_percentoffering",                     precision: 5, scale: 2
        t.decimal "invoffering_highyield_percentactive",                       precision: 5, scale: 2
        t.decimal "invoffering_highyield_percentpassive",                      precision: 5, scale: 2
        t.decimal "invoffering_largevalue_percentoffering",                    precision: 5, scale: 2
        t.decimal "invoffering_largevalue_percentactive",                      precision: 5, scale: 2
        t.decimal "invoffering_largevalue_percentpassive",                     precision: 5, scale: 2
        t.decimal "invoffering_largeblend_percentoffering",                    precision: 5, scale: 2
        t.decimal "invoffering_largeblend_percentactive",                      precision: 5, scale: 2
        t.decimal "invoffering_largeblend_percentpassive",                     precision: 5, scale: 2
        t.decimal "invoffering_largegrowth_percentoffering",                   precision: 5, scale: 2
        t.decimal "invoffering_largegrowth_percentactive",                     precision: 5, scale: 2
        t.decimal "invoffering_largegrowth_percentpassive",                    precision: 5, scale: 2
        t.decimal "invoffering_midvalue_percentoffering",                      precision: 5, scale: 2
        t.decimal "invoffering_midvalue_percentactive",                        precision: 5, scale: 2
        t.decimal "invoffering_midvalue_percentpassive",                       precision: 5, scale: 2
        t.decimal "invoffering_midblend_percentoffering",                      precision: 5, scale: 2
        t.decimal "invoffering_midblend_percentactive",                        precision: 5, scale: 2
        t.decimal "invoffering_midblend_percentpassive",                       precision: 5, scale: 2
        t.decimal "invoffering_midgrowth_percentoffering",                     precision: 5, scale: 2
        t.decimal "invoffering_midgrowth_percentactive",                       precision: 5, scale: 2
        t.decimal "invoffering_midgrowth_percentpassive",                      precision: 5, scale: 2
        t.decimal "invoffering_smallvalue_percentoffering",                    precision: 5, scale: 2
        t.decimal "invoffering_smallvalue_percentactive",                      precision: 5, scale: 2
        t.decimal "invoffering_smallvalue_percentpassive",                     precision: 5, scale: 2
        t.decimal "invoffering_smallblend_percentoffering",                    precision: 5, scale: 2
        t.decimal "invoffering_smallblend_percentactive",                      precision: 5, scale: 2
        t.decimal "invoffering_smallblend_percentpassive",                     precision: 5, scale: 2
        t.decimal "invoffering_smallgrowth_percentoffering",                   precision: 5, scale: 2
        t.decimal "invoffering_smallgrowth_percentactive",                     precision: 5, scale: 2
        t.decimal "invoffering_smallgrowth_percentpassive",                    precision: 5, scale: 2
        t.decimal "invoffering_international_percentoffering",                 precision: 5, scale: 2
        t.decimal "invoffering_international_percentactive",                   precision: 5, scale: 2
        t.decimal "invoffering_international_percentpassive",                  precision: 5, scale: 2
        t.decimal "invoffering_emergingmarkets_percentoffering",               precision: 5, scale: 2
        t.decimal "invoffering_emergingmarkets_percentactive",                 precision: 5, scale: 2
        t.decimal "invoffering_emergingmarkets_percentpassive",                precision: 5, scale: 2
        t.decimal "invoffering_global_percentoffering",                        precision: 5, scale: 2
        t.decimal "invoffering_global_percentactive",                          precision: 5, scale: 2
        t.decimal "invoffering_global_percentpassive",                         precision: 5, scale: 2
        t.decimal "invoffering_realestate_percentoffering",                    precision: 5, scale: 2
        t.decimal "invoffering_realestate_percentactive",                      precision: 5, scale: 2
        t.decimal "invoffering_realestate_percentpassive",                     precision: 5, scale: 2
        t.decimal "invoffering_alternatives_percentoffering",                  precision: 5, scale: 2
        t.decimal "invoffering_alternatives_percentactive",                    precision: 5, scale: 2
        t.decimal "invoffering_alternatives_percentpassive",                   precision: 5, scale: 2
        t.decimal "invoffering_others_percentoffering",                        precision: 5, scale: 2
        t.decimal "invoffering_others_percentactive",                          precision: 5, scale: 2
        t.decimal "invoffering_others_percentpassive",                         precision: 5, scale: 2
        t.decimal "invoffering_sdas_percentoffering",                          precision: 5, scale: 2
        t.decimal "invoffering_costock_percentoffering",                       precision: 5, scale: 2
        t.decimal "generalaccount_expenseratiofeeoffsets_25th",                precision: 8, scale: 5
        t.decimal "generalaccount_expenseratiofeeoffsets_50th",                precision: 8, scale: 5
        t.decimal "generalaccount_expenseratiofeeoffsets_75th",                precision: 8, scale: 5
        t.decimal "generalaccount_percent_currentratereset_monthly",           precision: 5, scale: 2
        t.decimal "generalaccount_percent_currentratereset_quarterly",         precision: 5, scale: 2
        t.decimal "generalaccount_percent_currentratereset_annually",          precision: 5, scale: 2
        t.decimal "generalaccount_percent_currentratereset_other",             precision: 5, scale: 2
        t.decimal "generalaccount_percent_minimumratereset_monthly",           precision: 5, scale: 2
        t.decimal "generalaccount_percent_minimumratereset_quarterly",         precision: 5, scale: 2
        t.decimal "generalaccount_percent_minimumratereset_annually",          precision: 5, scale: 2
        t.decimal "generalaccount_percent_minimumratereset_other",             precision: 5, scale: 2
        t.decimal "generalaccount_percent_blendedratereset_monthly",           precision: 5, scale: 2
        t.decimal "generalaccount_percent_blendedratereset_quarterly",         precision: 5, scale: 2
        t.decimal "generalaccount_percent_blendedratereset_annually",          precision: 5, scale: 2
        t.decimal "generalaccount_percent_blendedratereset_other",             precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aaa_plus",    precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aaa_flat",    precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aaa_minus",   precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aa_plus",     precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aa_flat",     precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_aa_minus",    precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_a_plus",      precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_a_flat",      precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_a_minus",     precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_bbb_plus",    precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_bbb_flat",    precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_bbb_minus",   precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_other_plus",  precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_other_flat",  precision: 5, scale: 2
        t.decimal "generalaccount_percent_creditqualityguarantor_other_minus", precision: 5, scale: 2
        t.decimal "generalaccount_percent_no_put_applies",                     precision: 5, scale: 2
        t.decimal "generalaccount_percent_12mo_put_applies",                   precision: 5, scale: 2
        t.decimal "generalaccount_percent_24mo_put_applies",                   precision: 5, scale: 2
        t.decimal "generalaccount_percent_36mo_put_applies",                   precision: 5, scale: 2
        t.decimal "generalaccount_percent_no_marketvalueadjustment_applies",   precision: 5, scale: 2
        t.decimal "generalaccount_percent_12mo_marketvalueadjustment_applies", precision: 5, scale: 2
        t.decimal "generalaccount_percent_24mo_marketvalueadjustment_applies", precision: 5, scale: 2
        t.decimal "generalaccount_percent_36mo_marketvalueadjustment_applies", precision: 5, scale: 2
        t.decimal "percent_assets_proprietary",                                precision: 5, scale: 2
      end

      create_table "bmg_inv_plans", force: true do |t|
        t.integer "bmg_inv_master_id"
        t.date    "vintage_date"
        t.integer "plan_id"
      end

      create_table "bmg_plan_complexities", force: true do |t|
        t.date    "vintage_date"
        t.integer "naics_2_digit_code_id"
        t.integer "naics_3_digit_code_id"
        t.integer "pcx_benchmark_group_id_score_5th"
        t.integer "pcx_benchmark_group_id_score_50th"
        t.integer "pcx_benchmark_group_id_score_95th"
        t.decimal "pcx_part_of_controlled_group_percent_yes",                  precision: 5, scale: 2
        t.decimal "pcx_part_of_controlled_group_percent_no",                   precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_immediate",                         precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_1_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_2_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_3_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_4_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_5_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_6_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_7_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_8_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_9_months",                          precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_10_months",                         precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_11_months",                         precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_12_months",                         precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_gt12_months",                       precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_multiple",                          precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_none",                                  precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_less_than_18",                          precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_18_to_18_99",                           precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_19_to_19_99",                           precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_20_to_20_99",                           precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_21",                                    precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_multiple",                              precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_immediate",                          precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_monthly",                            precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_quarterly",                          precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_semi_annually",                      precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_annually",                           precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_other",                              precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_none",                               precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_yes_new_hires",                      precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_yes_all_employees",                  precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_1percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_2percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_3percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_4percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_5percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_6percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_7percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_8percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_9percent",                             precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_10percent",                            precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_gt10percent",                          precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_none",                             precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_yes",                              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_1percent",              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_2percent",              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_3percent",              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_4percent",              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_5percent",              precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_gt5percent",            precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_1percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_2percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_3percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_4percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_5percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_6percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_7percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_8percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_9percent",                 precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_10percent",                precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_gt10percent",              precision: 5, scale: 2
        t.decimal "pcx_pretax_percent_no",                                     precision: 5, scale: 2
        t.decimal "pcx_pretax_percent_yes",                                    precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_0percent_5percent",                  precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_6percent_10percent",                 precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_11percent_15percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_16percent_20percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_21percent_25percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_26percent_30percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_31percent_35percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_36percent_40percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_41percent_45percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_46percent_50percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_51percent_55percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_56percent_60percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_61percent_65percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_66percent_70percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_71percent_75percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_76percent_80percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_81percent_85percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_86percent_90percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_91percent_95percent",                precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_96percent_100percent",               precision: 5, scale: 2
        t.decimal "pcx_roth_percent_no",                                       precision: 5, scale: 2
        t.decimal "pcx_roth_percent_yes",                                      precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_0percent_5percent",                    precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_6percent_10percent",                   precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_11percent_15percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_16percent_20percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_21percent_25percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_26percent_30percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_31percent_35percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_36percent_40percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_41percent_45percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_46percent_50percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_51percent_55percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_56percent_60percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_61percent_65percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_66percent_70percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_71percent_75percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_76percent_80percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_81percent_85percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_86percent_90percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_91percent_95percent",                  precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_96percent_100percent",                 precision: 5, scale: 2
        t.decimal "pcx_catchup_percent_no",                                    precision: 5, scale: 2
        t.decimal "pcx_catchup_percent_yes",                                   precision: 5, scale: 2
        t.decimal "pcx_aftertax_percent_no",                                   precision: 5, scale: 2
        t.decimal "pcx_aftertax_percent_yes",                                  precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_0percent_5percent",                precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_6percent_10percent",               precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_11percent_15percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_16percent_20percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_21percent_25percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_26percent_30percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_31percent_35percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_36percent_40percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_41percent_45percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_46percent_50percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_51percent_55percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_56percent_60percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_61percent_65percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_66percent_70percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_71percent_75percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_76percent_80percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_81percent_85percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_86percent_90percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_91percent_95percent",              precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_96percent_100percent",             precision: 5, scale: 2
        t.decimal "pcx_rolloverin_percent_no",                                 precision: 5, scale: 2
        t.decimal "pcx_rolloverin_percent_yes",                                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_formula_percent_discretionary",       precision: 5, scale: 2
        t.decimal "pcx_employer_matching_formula_percentage_fixed",            precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_immediate",           precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_2_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_3_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_4_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_5_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_6_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_1_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_2_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_3_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_other",               precision: 5, scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_no",                      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_yes",                     precision: 5, scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_no",                 precision: 5, scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_yes",                precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_percent_no",                     precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_percent_yes",                    precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_immediate",      precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_2_years", precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_3_years", precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_4_years", precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_5_years", precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_6_years", precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_1_yrs",    precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_2_yrs",    precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_3_yrs",    precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_other",          precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_no",                 precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_yes",                precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_no",            precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_yes",           precision: 5, scale: 2
        t.decimal "pcx_employer_required_none",                                precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_std",   precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_other", precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_std",   precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_other", precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent",             precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent_amtcap",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_integrated",                  precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_pointsformula",               precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_other",                       precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_immediate",           precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_2_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_3_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_4_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_5_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_6_years",      precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_1_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_2_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_3_yrs",         precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_other",               precision: 5, scale: 2
        t.decimal "pcx_employer_required_eoy_percent_no",                      precision: 5, scale: 2
        t.decimal "pcx_employer_required_eoy_percent_yes",                     precision: 5, scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_no",                 precision: 5, scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_yes",                precision: 5, scale: 2
        t.decimal "pcx_target_date_funds_no",                                  precision: 5, scale: 2
        t.decimal "pcx_target_date_funds_yes",                                 precision: 5, scale: 2
        t.decimal "pcx_risk_based_funds_no",                                   precision: 5, scale: 2
        t.decimal "pcx_risk_based_funds_yes",                                  precision: 5, scale: 2
        t.decimal "pcx_model_portfolios_from_core_no",                         precision: 5, scale: 2
        t.decimal "pcx_model_portfolios_from_core_yes",                        precision: 5, scale: 2
        t.decimal "pcx_managed_account_from_core_no",                          precision: 5, scale: 2
        t.decimal "pcx_managed_account_from_core_yes",                         precision: 5, scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_no",                     precision: 5, scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_yes",                    precision: 5, scale: 2
        t.integer "pcx_number_of_core_options_from_core_no"
        t.integer "pcx_number_of_core_options_from_core_yes"
        t.integer "pcx_number_of_core_assetclasses_from_core_no"
        t.integer "pcx_number_of_core_assetclasses_from_core_yes"
        t.decimal "pcx_auto_rebalance_percent_no",                             precision: 5, scale: 2
        t.decimal "pcx_auto_rebalance_percent_yes",                            precision: 5, scale: 2
        t.decimal "pcx_sda_percent_no",                                        precision: 5, scale: 2
        t.decimal "pcx_sda_percent_yes",                                       precision: 5, scale: 2
        t.decimal "pcx_company_stock_percent_no",                              precision: 5, scale: 2
        t.decimal "pcx_company_stock_percent_yes",                             precision: 5, scale: 2
        t.decimal "pcx_loans_allowed_percent_no",                              precision: 5, scale: 2
        t.decimal "pcx_loans_allowed_percent_yes",                             precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_only",               precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_residential_only",           precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_and_residential",    precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_1",                           precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_2",                           precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_3",                           precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_4",                           precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_5",                           precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_gt5",                         precision: 5, scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_no",                       precision: 5, scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_yes",                      precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_no",                       precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_yes",                      precision: 5, scale: 2
        t.decimal "pcx_hardship_loans_percent_no",                             precision: 5, scale: 2
        t.decimal "pcx_hardship_loans_percent_yes",                            precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_and_hardship_loans_percent_yes",   precision: 5, scale: 2
        t.decimal "pcx_installment_payments_percent_no",                       precision: 5, scale: 2
        t.decimal "pcx_installment_payments_percent_yes",                      precision: 5, scale: 2
        t.decimal "pcx_annuities_percent_no",                                  precision: 5, scale: 2
        t.decimal "pcx_annuities_percent_yes",                                 precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_none",                                 precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_amt1000",                              precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_amt5000",                              precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_other",                                precision: 5, scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_no",                    precision: 5, scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_yes",                   precision: 5, scale: 2
        t.decimal "pcx_lifetime_income_service_no",                            precision: 5, scale: 2
        t.decimal "pcx_lifetime_income_service_yes",                           precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_daily",                     precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_annual",                    precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_semi_annual",               precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_quarterly",                 precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_monthly",                   precision: 5, scale: 2
      end

      create_table "bmg_plan_complexity_fees", force: true do |t|
        t.string  "pcx_fees_benchmark_group_id",                               limit: 6
        t.date    "pcx_fees_benchmark_group_id_date"
        t.integer "pcx_benchmark_group_id_5th_score"
        t.integer "pcx_benchmark_group_id_50th_score"
        t.integer "pcx_benchmark_group_id_95th_score"
        t.decimal "pcx_part_of_controlled_group_percent_yes",                            precision: 5, scale: 2
        t.decimal "pcx_part_of_controlled_group_percent_no",                             precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_immediate",                                   precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_1_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_2_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_3_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_4_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_5_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_6_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_7_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_8_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_9_months",                                    precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_10_months",                                   precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_11_months",                                   precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_12_months",                                   precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_gt12_months",                                 precision: 5, scale: 2
        t.decimal "pcx_eligservice_percent_multiple",                                    precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_none",                                            precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_less_than_18",                                    precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_18_to_18_99",                                     precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_19_to_19_99",                                     precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_20_to_20_99",                                     precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_21",                                              precision: 5, scale: 2
        t.decimal "pcx_eligage_percent_multiple",                                        precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_immediate",                                    precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_monthly",                                      precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_quarterly",                                    precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_semi_annually",                                precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_annually",                                     precision: 5, scale: 2
        t.decimal "pcx_entry_date_percent_other",                                        precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_none",                                         precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_yes_new_hires",                                precision: 5, scale: 2
        t.decimal "pcx_autoenroll_percent_yes_all_employees",                            precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_1percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_2percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_3percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_4percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_5percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_6percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_7percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_8percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_9percent",                                       precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_10percent",                                      precision: 5, scale: 2
        t.decimal "pcx_autoenroll_start_gt10percent",                                    precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_none",                                       precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_yes",                                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_1percent",                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_2percent",                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_3percent",                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_4percent",                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_5percent",                        precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_gt5percent",                      precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_1percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_2percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_3percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_4percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_5percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_6percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_7percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_8percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_9percent",                           precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_10percent",                          precision: 5, scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_gt10percent",                        precision: 5, scale: 2
        t.decimal "pcx_pretax_percent_no",                                               precision: 5, scale: 2
        t.decimal "pcx_pretax_percent_yes",                                              precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_0percent_5percent",                            precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_6percent_10percent",                           precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_11percent_15percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_16percent_20percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_21percent_25percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_26percent_30percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_31percent_35percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_36percent_40percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_41percent_45percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_46percent_50percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_51percent_55percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_56percent_60percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_61percent_65percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_66percent_70percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_71percent_75percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_76percent_80percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_81percent_85percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_86percent_90percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_91percent_95percent",                          precision: 5, scale: 2
        t.decimal "pcx_pretax_max_percent_96percent_100percent",                         precision: 5, scale: 2
        t.decimal "pcx_roth_percent_no",                                                 precision: 5, scale: 2
        t.decimal "pcx_roth_percent_yes",                                                precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_0percent_5percent",                              precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_6percent_10percent",                             precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_11percent_15percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_16percent_20percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_21percent_25percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_26percent_30percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_31percent_35percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_36percent_40percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_41percent_45percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_46percent_50percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_51percent_55percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_56percent_60percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_61percent_65percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_66percent_70percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_71percent_75percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_76percent_80percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_81percent_85percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_86percent_90percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_91percent_95percent",                            precision: 5, scale: 2
        t.decimal "pcx_roth_max_percent_96percent_100percent",                           precision: 5, scale: 2
        t.decimal "pcx_catchup_percent_no",                                              precision: 5, scale: 2
        t.decimal "pcx_catchup_percent_yes",                                             precision: 5, scale: 2
        t.decimal "pcx_aftertax_percent_no",                                             precision: 5, scale: 2
        t.decimal "pcx_aftertax_percent_yes",                                            precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_0percent_5percent",                          precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_6percent_10percent",                         precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_11percent_15percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_16percent_20percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_21percent_25percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_26percent_30percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_31percent_35percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_36percent_40percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_41percent_45percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_46percent_50percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_51percent_55percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_56percent_60percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_61percent_65percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_66percent_70percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_71percent_75percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_76percent_80percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_81percent_85percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_86percent_90percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_91percent_95percent",                        precision: 5, scale: 2
        t.decimal "pcx_aftertax_max_percent_96percent_100percent",                       precision: 5, scale: 2
        t.decimal "pcx_rolloverin_percent_no",                                           precision: 5, scale: 2
        t.decimal "pcx_rolloverin_percent_yes",                                          precision: 5, scale: 2
        t.decimal "pcx_employer_matching_formula_percent_discretionary",                 precision: 5, scale: 2
        t.decimal "pcx_employer_matching_formula_percentage_fixed",                      precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_immediate",                     precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_2_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_3_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_4_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_5_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_6_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_1_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_2_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_3_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_other",                         precision: 5, scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_no",                                precision: 5, scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_yes",                               precision: 5, scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_no",                           precision: 5, scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_yes",                          precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_percent_no",                               precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_percent_yes",                              precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_immediate",                precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_2_years",           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_3_years",           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_4_years",           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_5_years",           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_6_years",           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_1_yrs",              precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_2_yrs",              precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_3_yrs",              precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_other",                    precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_no",                           precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_yes",                          precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_no",                      precision: 5, scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_yes",                     precision: 5, scale: 2
        t.decimal "pcx_employer_required_none",                                          precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_std",             precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_other",           precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_std",             precision: 5, scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_other",           precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent",                       precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent_amtcap",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_integrated",                            precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_pointsformula",                         precision: 5, scale: 2
        t.decimal "pcx_employer_required_percent_other",                                 precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_immediate",                     precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_2_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_3_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_4_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_5_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_6_years",                precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_1_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_2_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_3_yrs",                   precision: 5, scale: 2
        t.decimal "pcx_employer_required_vesting_percent_other",                         precision: 5, scale: 2
        t.decimal "pcx_employer_required_eoy_percent_no",                                precision: 5, scale: 2
        t.decimal "pcx_employer_required_eoy_percent_yes",                               precision: 5, scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_no",                           precision: 5, scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_yes",                          precision: 5, scale: 2
        t.decimal "pcx_target_date_funds_no",                                            precision: 5, scale: 2
        t.decimal "pcx_target_date_funds_yes",                                           precision: 5, scale: 2
        t.decimal "pcx_risk_based_funds_no",                                             precision: 5, scale: 2
        t.decimal "pcx_risk_based_funds_yes",                                            precision: 5, scale: 2
        t.decimal "pcx_model_portfolios_from_core_no",                                   precision: 5, scale: 2
        t.decimal "pcx_model_portfolios_from_core_yes",                                  precision: 5, scale: 2
        t.decimal "pcx_managed_account_from_core_no",                                    precision: 5, scale: 2
        t.decimal "pcx_managed_account_from_core_yes",                                   precision: 5, scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_no",                               precision: 5, scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_yes",                              precision: 5, scale: 2
        t.integer "pcx_number_of_core_options_from_core_no"
        t.integer "pcx_number_of_core_options_from_core_yes"
        t.integer "pcx_number_of_core_assetclasses_from_core_no"
        t.integer "pcx_number_of_core_assetclasses_from_core_yes"
        t.decimal "pcx_auto_rebalance_percent_no",                                       precision: 5, scale: 2
        t.decimal "pcx_auto_rebalance_percent_yes",                                      precision: 5, scale: 2
        t.decimal "pcx_sda_percent_no",                                                  precision: 5, scale: 2
        t.decimal "pcx_sda_percent_yes",                                                 precision: 5, scale: 2
        t.decimal "pcx_company_stock_percent_no",                                        precision: 5, scale: 2
        t.decimal "pcx_company_stock_percent_yes",                                       precision: 5, scale: 2
        t.decimal "pcx_loans_allowed_percent_no",                                        precision: 5, scale: 2
        t.decimal "pcx_loans_allowed_percent_yes",                                       precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_only",                         precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_residential_only",                     precision: 5, scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_and_residential",              precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_1",                                     precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_2",                                     precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_3",                                     precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_4",                                     precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_5",                                     precision: 5, scale: 2
        t.decimal "pcx_max_loans_allowed_percent_gt5",                                   precision: 5, scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_no",                                 precision: 5, scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_yes",                                precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_no",                                 precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_yes",                                precision: 5, scale: 2
        t.decimal "pcx_hardship_loans_percent_no",                                       precision: 5, scale: 2
        t.decimal "pcx_hardship_loans_percent_yes",                                      precision: 5, scale: 2
        t.decimal "pcx_hardship_withdrawals_and_hardship_loans_percent_yes",             precision: 5, scale: 2
        t.decimal "pcx_installment_payments_percent_no",                                 precision: 5, scale: 2
        t.decimal "pcx_installment_payments_percent_yes",                                precision: 5, scale: 2
        t.decimal "pcx_annuities_percent_no",                                            precision: 5, scale: 2
        t.decimal "pcx_annuities_percent_yes",                                           precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_none",                                           precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_amt1000",                                        precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_amt5000",                                        precision: 5, scale: 2
        t.decimal "pcx_cash_out_percent_other",                                          precision: 5, scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_no",                              precision: 5, scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_yes",                             precision: 5, scale: 2
        t.decimal "pcx_lifetime_income_service_no",                                      precision: 5, scale: 2
        t.decimal "pcx_lifetime_income_service_yes",                                     precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_daily",                               precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_annual",                              precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_semi_annual",                         precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_quarterly",                           precision: 5, scale: 2
        t.decimal "pcx_valuation_frequency_percent_monthly",                             precision: 5, scale: 2
      end

      create_table "bmg_plan_complexity_fees_plans", force: true do |t|
        t.date    "vintage_date"
        t.integer "plan_id"
        t.integer "pcx_score"
      end

      create_table "bmg_psm_groups", force: true do |t|
        t.date    "vintage_date"
        t.integer "naics_2_digit_market_segment_id"
        t.integer "naics_3_digit_market_segment_id"
      end

      create_table "bmg_psm_masters", force: true do |t|
        t.string "name", limit: 64
      end

      create_table "bmg_psm_singles", force: true do |t|
        t.integer "bmg_psm_group_id"
        t.integer "bmg_psm_master_id"
        t.decimal "percent_responding", precision: 5, scale: 2
        t.decimal "value_low",          precision: 5, scale: 2
        t.decimal "value_5th",          precision: 5, scale: 2
        t.decimal "value_25th",         precision: 5, scale: 2
        t.decimal "value_50th",         precision: 5, scale: 2
        t.decimal "value_75th",         precision: 5, scale: 2
        t.decimal "value_95th",         precision: 5, scale: 2
        t.decimal "value_high",         precision: 5, scale: 2
      end

      create_table "bmg_rk_investment_fees", force: true do |t|
        t.integer "market_segment_id"
        t.integer "fbi_asset_class_id"
        t.integer "investment_strategy_id"
        t.decimal "to_rk_25th",             precision: 8, scale: 5
        t.decimal "to_rk_50th",             precision: 8, scale: 5
        t.decimal "to_rk_75th",             precision: 8, scale: 5
      end

      create_table "bmg_rk_masters", force: true do |t|
        t.date    "vintage_date"
        t.integer "rk_bmg_assets_low"
        t.integer "rk_bmg_assets_50th"
        t.integer "rk_bmg_assets_high"
        t.integer "rk_bmg_participants_low"
        t.integer "rk_bmg_participants_high"
        t.integer "rk_bmg_participants_avgbalance_low"
        t.integer "rk_bmg_participants_avgbalance_high"
        t.decimal "rk_bmg_correlation_coefficient",                                 precision: 6,  scale: 3
        t.decimal "rk_bmg_regressionline_slope_value",                              precision: 8,  scale: 5
        t.decimal "rk_bmg_regressionline_constant_value",                           precision: 7,  scale: 2
        t.integer "rk_total_plans"
        t.integer "rk_planstype_401k"
        t.integer "rk_planstype_403b"
        t.integer "rk_planstype_other"
        t.integer "rk_plans_insco"
        t.integer "rk_plans_mutualfunds"
        t.integer "rk_plans_bank"
        t.integer "rk_plans_tpa"
        t.integer "rk_plans_other"
        t.integer "rk_total_rks"
        t.integer "rk_rkbusinessmodel_insco"
        t.integer "rk_rkbusinessmodel_mutualfunds"
        t.integer "rk_rkbusinessmodel_bank"
        t.integer "rk_rkbusinessmodel_tpa"
        t.integer "rk_rkbusinessmodel_other"
        t.decimal "rk_totalfees_dollars_5th",                                       precision: 12, scale: 2
        t.decimal "rk_totalfees_dollars_25th",                                      precision: 12, scale: 2
        t.decimal "rk_totalfees_dollars_50th",                                      precision: 12, scale: 2
        t.decimal "rk_totalfees_dollars_75th",                                      precision: 12, scale: 2
        t.decimal "rk_totalfees_dollars_95th",                                      precision: 12, scale: 2
        t.decimal "rk_totalfees_bps_5th",                                           precision: 7,  scale: 4
        t.decimal "rk_totalfees_bps_25th",                                          precision: 7,  scale: 4
        t.decimal "rk_totalfees_bps_50th",                                          precision: 7,  scale: 4
        t.decimal "rk_totalfees_bps_75th",                                          precision: 7,  scale: 4
        t.decimal "rk_totalfees_bps_95th",                                          precision: 7,  scale: 4
        t.decimal "rk_totalfees_perpart_5th",                                       precision: 9,  scale: 2
        t.decimal "rk_totalfees_perpart_25th",                                      precision: 9,  scale: 2
        t.decimal "rk_totalfees_perpart_50th",                                      precision: 9,  scale: 2
        t.decimal "rk_totalfees_perpart_75th",                                      precision: 9,  scale: 2
        t.decimal "rk_totalfees_perpart_95th",                                      precision: 9,  scale: 2
        t.decimal "rk_ter_aggressive_allocation_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_aggressive_allocation_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_aggressive_allocation_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_bank_loan_investmentfees_to_rk_25th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_bank_loan_investmentfees_to_rk_50th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_bank_loan_investmentfees_to_rk_75th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_bear_market_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_bear_market_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_bear_market_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_cash_investmentfees_to_rk_25th",                          precision: 8,  scale: 5
        t.decimal "rk_ter_cash_investmentfees_to_rk_50th",                          precision: 8,  scale: 5
        t.decimal "rk_ter_cash_investmentfees_to_rk_75th",                          precision: 8,  scale: 5
        t.decimal "rk_ter_china_region_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_china_region_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_china_region_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_agriculture_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_agriculture_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_agriculture_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_broad_basket_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_broad_basket_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_broad_basket_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_energy_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_energy_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_energy_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_industrial_metals_investmentfees_to_rk_25th", precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_industrial_metals_investmentfees_to_rk_50th", precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_industrial_metals_investmentfees_to_rk_75th", precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_miscellaneous_investmentfees_to_rk_25th",     precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_miscellaneous_investmentfees_to_rk_50th",     precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_miscellaneous_investmentfees_to_rk_75th",     precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_precious_metals_investmentfees_to_rk_25th",   precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_precious_metals_investmentfees_to_rk_50th",   precision: 8,  scale: 5
        t.decimal "rk_ter_commodities_precious_metals_investmentfees_to_rk_75th",   precision: 8,  scale: 5
        t.decimal "rk_ter_communications_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_communications_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_communications_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_conservative_allocation_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_conservative_allocation_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_conservative_allocation_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_cyclical_investmentfees_to_rk_25th",             precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_cyclical_investmentfees_to_rk_50th",             precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_cyclical_investmentfees_to_rk_75th",             precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_defensive_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_defensive_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_consumer_defensive_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_convertibles_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_convertibles_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_convertibles_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_currency_investmentfees_to_rk_25th",                      precision: 8,  scale: 5
        t.decimal "rk_ter_currency_investmentfees_to_rk_50th",                      precision: 8,  scale: 5
        t.decimal "rk_ter_currency_investmentfees_to_rk_75th",                      precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_emerging_mkts_investmentfees_to_rk_25th",     precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_emerging_mkts_investmentfees_to_rk_50th",     precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_emerging_mkts_investmentfees_to_rk_75th",     precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_pacific_asia_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_pacific_asia_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_diversified_pacific_asia_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_emerging_markets_bond_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_emerging_markets_bond_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_emerging_markets_bond_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_equity_energy_investmentfees_to_rk_25th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_equity_energy_investmentfees_to_rk_50th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_equity_energy_investmentfees_to_rk_75th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_equity_precious_metals_investmentfees_to_rk_25th",        precision: 8,  scale: 5
        t.decimal "rk_ter_equity_precious_metals_investmentfees_to_rk_50th",        precision: 8,  scale: 5
        t.decimal "rk_ter_equity_precious_metals_investmentfees_to_rk_75th",        precision: 8,  scale: 5
        t.decimal "rk_ter_europe_stock_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_europe_stock_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_europe_stock_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_financial_investmentfees_to_rk_25th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_financial_investmentfees_to_rk_50th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_financial_investmentfees_to_rk_75th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_blend_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_blend_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_blend_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_growth_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_growth_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_growth_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_value_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_value_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_large_value_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_blend_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_blend_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_blend_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_growth_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_growth_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_growth_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_value_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_value_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_foreign_small_mid_value_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_general_account_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_general_account_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_general_account_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_global_real_estate_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_global_real_estate_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_global_real_estate_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_health_investmentfees_to_rk_25th",                        precision: 8,  scale: 5
        t.decimal "rk_ter_health_investmentfees_to_rk_50th",                        precision: 8,  scale: 5
        t.decimal "rk_ter_health_investmentfees_to_rk_75th",                        precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_bond_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_bond_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_bond_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_muni_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_muni_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_high_yield_muni_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_india_equity_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_india_equity_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_india_equity_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_industrials_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_industrials_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_industrials_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_inflation_protected_bond_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_inflation_protected_bond_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_inflation_protected_bond_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_government_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_government_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_government_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_term_bond_investmentfees_to_rk_25th",        precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_term_bond_investmentfees_to_rk_50th",        precision: 8,  scale: 5
        t.decimal "rk_ter_intermediate_term_bond_investmentfees_to_rk_75th",        precision: 8,  scale: 5
        t.decimal "rk_ter_japan_stock_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_japan_stock_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_japan_stock_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_blend_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_blend_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_blend_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_growth_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_large_growth_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_large_growth_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_large_value_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_value_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_large_value_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_latin_america_stock_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_latin_america_stock_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_latin_america_stock_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_leveraged_net_long_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_leveraged_net_long_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_leveraged_net_long_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_long_government_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_long_government_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_long_government_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_long_short_equity_investmentfees_to_rk_25th",             precision: 8,  scale: 5
        t.decimal "rk_ter_long_short_equity_investmentfees_to_rk_50th",             precision: 8,  scale: 5
        t.decimal "rk_ter_long_short_equity_investmentfees_to_rk_75th",             precision: 8,  scale: 5
        t.decimal "rk_ter_long_term_bond_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_long_term_bond_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_long_term_bond_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_managed_futures_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_managed_futures_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_managed_futures_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_market_neutral_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_market_neutral_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_market_neutral_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_blend_investmentfees_to_rk_25th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_blend_investmentfees_to_rk_50th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_blend_investmentfees_to_rk_75th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_growth_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_growth_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_growth_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_value_investmentfees_to_rk_25th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_value_investmentfees_to_rk_50th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_mid_cap_value_investmentfees_to_rk_75th",                 precision: 8,  scale: 5
        t.decimal "rk_ter_miscellaneous_sector_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_miscellaneous_sector_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_miscellaneous_sector_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_moderate_allocation_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_moderate_allocation_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_moderate_allocation_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_taxable_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_taxable_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_taxable_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_tax_free_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_tax_free_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_money_market_tax_free_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_multialternative_investmentfees_to_rk_25th",              precision: 8,  scale: 5
        t.decimal "rk_ter_multialternative_investmentfees_to_rk_50th",              precision: 8,  scale: 5
        t.decimal "rk_ter_multialternative_investmentfees_to_rk_75th",              precision: 8,  scale: 5
        t.decimal "rk_ter_multisector_bond_investmentfees_to_rk_25th",              precision: 8,  scale: 5
        t.decimal "rk_ter_multisector_bond_investmentfees_to_rk_50th",              precision: 8,  scale: 5
        t.decimal "rk_ter_multisector_bond_investmentfees_to_rk_75th",              precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_intermediate_investmentfees_to_rk_25th",  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_intermediate_investmentfees_to_rk_50th",  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_intermediate_investmentfees_to_rk_75th",  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_long_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_long_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_california_long_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_florida_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_florida_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_florida_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_muni_massachusetts_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_massachusetts_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_massachusetts_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_minnesota_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_muni_minnesota_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_muni_minnesota_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_interm_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_interm_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_interm_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_long_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_long_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_long_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_short_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_short_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_muni_national_short_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_jersey_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_jersey_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_jersey_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_intermediate_investmentfees_to_rk_25th",    precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_intermediate_investmentfees_to_rk_50th",    precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_intermediate_investmentfees_to_rk_75th",    precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_long_investmentfees_to_rk_25th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_long_investmentfees_to_rk_50th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_new_york_long_investmentfees_to_rk_75th",            precision: 8,  scale: 5
        t.decimal "rk_ter_muni_ohio_investmentfees_to_rk_25th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_muni_ohio_investmentfees_to_rk_50th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_muni_ohio_investmentfees_to_rk_75th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_muni_pennsylvania_investmentfees_to_rk_25th",             precision: 8,  scale: 5
        t.decimal "rk_ter_muni_pennsylvania_investmentfees_to_rk_50th",             precision: 8,  scale: 5
        t.decimal "rk_ter_muni_pennsylvania_investmentfees_to_rk_75th",             precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_interm_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_interm_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_interm_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_long_investmentfees_to_rk_25th",        precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_long_investmentfees_to_rk_50th",        precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_long_investmentfees_to_rk_75th",        precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_short_investmentfees_to_rk_25th",       precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_short_investmentfees_to_rk_50th",       precision: 8,  scale: 5
        t.decimal "rk_ter_muni_single_state_short_investmentfees_to_rk_75th",       precision: 8,  scale: 5
        t.decimal "rk_ter_natural_resources_investmentfees_to_rk_25th",             precision: 8,  scale: 5
        t.decimal "rk_ter_natural_resources_investmentfees_to_rk_50th",             precision: 8,  scale: 5
        t.decimal "rk_ter_natural_resources_investmentfees_to_rk_75th",             precision: 8,  scale: 5
        t.decimal "rk_ter_nontraditional_bond_investmentfees_to_rk_25th",           precision: 8,  scale: 5
        t.decimal "rk_ter_nontraditional_bond_investmentfees_to_rk_50th",           precision: 8,  scale: 5
        t.decimal "rk_ter_nontraditional_bond_investmentfees_to_rk_75th",           precision: 8,  scale: 5
        t.decimal "rk_ter_pacific_asia_ex_japan_stk_investmentfees_to_rk_25th",     precision: 8,  scale: 5
        t.decimal "rk_ter_pacific_asia_ex_japan_stk_investmentfees_to_rk_50th",     precision: 8,  scale: 5
        t.decimal "rk_ter_pacific_asia_ex_japan_stk_investmentfees_to_rk_75th",     precision: 8,  scale: 5
        t.decimal "rk_ter_private_equity_investmentfees_to_rk_25th",                precision: 8,  scale: 5
        t.decimal "rk_ter_private_equity_investmentfees_to_rk_50th",                precision: 8,  scale: 5
        t.decimal "rk_ter_private_equity_investmentfees_to_rk_75th",                precision: 8,  scale: 5
        t.decimal "rk_ter_real_estate_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_real_estate_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_real_estate_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_retirement_income_investmentfees_to_rk_25th",             precision: 8,  scale: 5
        t.decimal "rk_ter_retirement_income_investmentfees_to_rk_50th",             precision: 8,  scale: 5
        t.decimal "rk_ter_retirement_income_investmentfees_to_rk_75th",             precision: 8,  scale: 5
        t.decimal "rk_ter_short_government_investmentfees_to_rk_25th",              precision: 8,  scale: 5
        t.decimal "rk_ter_short_government_investmentfees_to_rk_50th",              precision: 8,  scale: 5
        t.decimal "rk_ter_short_government_investmentfees_to_rk_75th",              precision: 8,  scale: 5
        t.decimal "rk_ter_short_term_bond_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_short_term_bond_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_short_term_bond_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_small_blend_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_small_blend_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_small_blend_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_small_growth_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_small_growth_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_small_growth_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_small_value_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_small_value_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_small_value_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_stable_value_investmentfees_to_rk_25th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_stable_value_investmentfees_to_rk_50th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_stable_value_investmentfees_to_rk_75th",                  precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2000_2010_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2000_2010_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2000_2010_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2011_2015_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2011_2015_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2011_2015_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2016_2020_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2016_2020_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2016_2020_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2021_2025_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2021_2025_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2021_2025_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2026_2030_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2026_2030_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2026_2030_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2031_2035_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2031_2035_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2031_2035_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2036_2040_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2036_2040_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2036_2040_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2041_2045_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2041_2045_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2041_2045_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2046_2050_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2046_2050_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2046_2050_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2051_plus_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2051_plus_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_target_date_2051_plus_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_technology_investmentfees_to_rk_25th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_technology_investmentfees_to_rk_50th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_technology_investmentfees_to_rk_75th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_commodities_investmentfees_to_rk_25th",   precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_commodities_investmentfees_to_rk_50th",   precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_commodities_investmentfees_to_rk_75th",   precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_debt_investmentfees_to_rk_25th",          precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_debt_investmentfees_to_rk_50th",          precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_debt_investmentfees_to_rk_75th",          precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_equity_investmentfees_to_rk_25th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_equity_investmentfees_to_rk_50th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_inverse_equity_investmentfees_to_rk_75th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_commodities_investmentfees_to_rk_25th", precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_commodities_investmentfees_to_rk_50th", precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_commodities_investmentfees_to_rk_75th", precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_debt_investmentfees_to_rk_25th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_debt_investmentfees_to_rk_50th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_debt_investmentfees_to_rk_75th",        precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_equity_investmentfees_to_rk_25th",      precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_equity_investmentfees_to_rk_50th",      precision: 8,  scale: 5
        t.decimal "rk_ter_trading_leveraged_equity_investmentfees_to_rk_75th",      precision: 8,  scale: 5
        t.decimal "rk_ter_trading_miscellaneous_investmentfees_to_rk_25th",         precision: 8,  scale: 5
        t.decimal "rk_ter_trading_miscellaneous_investmentfees_to_rk_50th",         precision: 8,  scale: 5
        t.decimal "rk_ter_trading_miscellaneous_investmentfees_to_rk_75th",         precision: 8,  scale: 5
        t.decimal "rk_ter_ultrashort_bond_investmentfees_to_rk_25th",               precision: 8,  scale: 5
        t.decimal "rk_ter_ultrashort_bond_investmentfees_to_rk_50th",               precision: 8,  scale: 5
        t.decimal "rk_ter_ultrashort_bond_investmentfees_to_rk_75th",               precision: 8,  scale: 5
        t.decimal "rk_ter_utilities_investmentfees_to_rk_25th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_utilities_investmentfees_to_rk_50th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_utilities_investmentfees_to_rk_75th",                     precision: 8,  scale: 5
        t.decimal "rk_ter_volatility_investmentfees_to_rk_25th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_volatility_investmentfees_to_rk_50th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_volatility_investmentfees_to_rk_75th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_world_allocation_investmentfees_to_rk_25th",              precision: 8,  scale: 5
        t.decimal "rk_ter_world_allocation_investmentfees_to_rk_50th",              precision: 8,  scale: 5
        t.decimal "rk_ter_world_allocation_investmentfees_to_rk_75th",              precision: 8,  scale: 5
        t.decimal "rk_ter_world_bond_investmentfees_to_rk_25th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_world_bond_investmentfees_to_rk_50th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_world_bond_investmentfees_to_rk_75th",                    precision: 8,  scale: 5
        t.decimal "rk_ter_world_stock_investmentfees_to_rk_25th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_world_stock_investmentfees_to_rk_50th",                   precision: 8,  scale: 5
        t.decimal "rk_ter_world_stock_investmentfees_to_rk_75th",                   precision: 8,  scale: 5
        t.decimal "rk_loanorigination_percent_plans_with_fee",                      precision: 5,  scale: 2
        t.decimal "rk_loanmaintenance_percent_plans_with_fee",                      precision: 5,  scale: 2
        t.decimal "rk_hardshipapproval_percent_plans_with_fee",                     precision: 5,  scale: 2
        t.decimal "rk_hardshipprocessing_percent_plans_with_fee",                   precision: 5,  scale: 2
        t.decimal "rk_qdroapproval_percent_plans_with_fee",                         precision: 5,  scale: 2
        t.decimal "rk_qdroprocessing_percent_plans_with_fee",                       precision: 5,  scale: 2
        t.decimal "rk_periodicpayment_setup_percent_plans_with_fee",                precision: 5,  scale: 2
        t.decimal "rk_periodicpayment_processing_percent_plans_with_fee",           precision: 5,  scale: 2
        t.decimal "rk_nonperiodicpayment_processing_percent_plans_with_fee",        precision: 5,  scale: 2
        t.decimal "managed_accounts_percentoffering",                               precision: 5,  scale: 2
        t.decimal "managed_accounts_percent_321fiduciary",                          precision: 5,  scale: 2
        t.decimal "managed_accounts_percent_338fiduciary",                          precision: 5,  scale: 2
        t.decimal "managed_accounts_fee_10kacctbalance_25th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_10kacctbalance_50th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_10kacctbalance_75th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_25th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_50th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_75th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_25th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_50th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_75th_321_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_25th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_50th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_75th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_25th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_50th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_75th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_25th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_50th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_75th_321_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_10kacctbalance_25th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_10kacctbalance_50th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_10kacctbalance_75th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_25th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_50th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_25kacctbalance_75th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_25th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_50th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_50kacctbalance_75th_338_fiduciary",         precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_25th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_50th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_100kacctbalance_75th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_25th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_50th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_250kacctbalance_75th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_25th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_50th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "managed_accounts_fee_500kacctbalance_75th_338_fiduciary",        precision: 7,  scale: 4
        t.decimal "sda_percentoffering",                                            precision: 5,  scale: 2
        t.decimal "sda_parts_using_25th",                                           precision: 5,  scale: 2
        t.decimal "sda_parts_using_50th",                                           precision: 5,  scale: 2
        t.decimal "sda_parts_using_75th",                                           precision: 5,  scale: 2
        t.decimal "sda_assets_percent_25th",                                        precision: 5,  scale: 2
        t.decimal "sda_assets_percent_50th",                                        precision: 5,  scale: 2
        t.decimal "sda_assets_percent_75th",                                        precision: 5,  scale: 2
        t.decimal "sda_fee_employerannual_25th",                                    precision: 9,  scale: 2
        t.decimal "sda_fee_employerannual_50th",                                    precision: 9,  scale: 2
        t.decimal "sda_fee_employerannual_75th",                                    precision: 9,  scale: 2
        t.decimal "sda_fee_participantminimum_25th",                                precision: 9,  scale: 2
        t.decimal "sda_fee_participantminimum_50th",                                precision: 9,  scale: 2
        t.decimal "sda_fee_participantminimum_75th",                                precision: 9,  scale: 2
        t.decimal "sda_fee_internetstock_25th",                                     precision: 9,  scale: 2
        t.decimal "sda_fee_internetstock_50th",                                     precision: 9,  scale: 2
        t.decimal "sda_fee_internetstock_75th",                                     precision: 9,  scale: 2
        t.decimal "sda_fee_phoneassistedstock_25th",                                precision: 9,  scale: 2
        t.decimal "sda_fee_phoneassistedstock_50th",                                precision: 9,  scale: 2
        t.decimal "sda_fee_phoneassistedstock_75th",                                precision: 9,  scale: 2
        t.integer "pcx_benchmark_group_id_score_5th"
        t.integer "pcx_benchmark_group_id_score_50th"
        t.integer "pcx_benchmark_group_id_score_95th"
        t.decimal "pcx_part_of_controlled_group_percent_yes",                       precision: 5,  scale: 2
        t.decimal "pcx_part_of_controlled_group_percent_no",                        precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_immediate",                              precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_1_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_2_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_3_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_4_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_5_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_6_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_7_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_8_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_9_months",                               precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_10_months",                              precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_11_months",                              precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_12_months",                              precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_gt12_months",                            precision: 5,  scale: 2
        t.decimal "pcx_eligservice_percent_multiple",                               precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_none",                                       precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_less_than_18",                               precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_18_to_18_99",                                precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_19_to_19_99",                                precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_20_to_20_99",                                precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_21",                                         precision: 5,  scale: 2
        t.decimal "pcx_eligage_percent_multiple",                                   precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_immediate",                               precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_monthly",                                 precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_quarterly",                               precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_semi_annually",                           precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_annually",                                precision: 5,  scale: 2
        t.decimal "pcx_entry_date_percent_other",                                   precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_percent_none",                                    precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_percent_yes_new_hires",                           precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_percent_yes_all_employees",                       precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_1percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_2percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_3percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_4percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_5percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_6percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_7percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_8percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_9percent",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_10percent",                                 precision: 5,  scale: 2
        t.decimal "pcx_autoenroll_start_gt10percent",                               precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_none",                                  precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_yes",                                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_1percent",                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_2percent",                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_3percent",                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_4percent",                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_5percent",                   precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_maxperyear_gt5percent",                 precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_1percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_2percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_3percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_4percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_5percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_6percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_7percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_8percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_9percent",                      precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_10percent",                     precision: 5,  scale: 2
        t.decimal "pcx_autoincrease_percent_ceiling_gt10percent",                   precision: 5,  scale: 2
        t.decimal "pcx_pretax_percent_no",                                          precision: 5,  scale: 2
        t.decimal "pcx_pretax_percent_yes",                                         precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_0percent_5percent",                       precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_6percent_10percent",                      precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_11percent_15percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_16percent_20percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_21percent_25percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_26percent_30percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_31percent_35percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_36percent_40percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_41percent_45percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_46percent_50percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_51percent_55percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_56percent_60percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_61percent_65percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_66percent_70percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_71percent_75percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_76percent_80percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_81percent_85percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_86percent_90percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_91percent_95percent",                     precision: 5,  scale: 2
        t.decimal "pcx_pretax_max_percent_96percent_100percent",                    precision: 5,  scale: 2
        t.decimal "pcx_roth_percent_no",                                            precision: 5,  scale: 2
        t.decimal "pcx_roth_percent_yes",                                           precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_0percent_5percent",                         precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_6percent_10percent",                        precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_11percent_15percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_16percent_20percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_21percent_25percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_26percent_30percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_31percent_35percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_36percent_40percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_41percent_45percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_46percent_50percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_51percent_55percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_56percent_60percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_61percent_65percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_66percent_70percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_71percent_75percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_76percent_80percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_81percent_85percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_86percent_90percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_91percent_95percent",                       precision: 5,  scale: 2
        t.decimal "pcx_roth_max_percent_96percent_100percent",                      precision: 5,  scale: 2
        t.decimal "pcx_catchup_percent_no",                                         precision: 5,  scale: 2
        t.decimal "pcx_catchup_percent_yes",                                        precision: 5,  scale: 2
        t.decimal "pcx_aftertax_percent_no",                                        precision: 5,  scale: 2
        t.decimal "pcx_aftertax_percent_yes",                                       precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_0percent_5percent",                     precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_6percent_10percent",                    precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_11percent_15percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_16percent_20percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_21percent_25percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_26percent_30percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_31percent_35percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_36percent_40percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_41percent_45percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_46percent_50percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_51percent_55percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_56percent_60percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_61percent_65percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_66percent_70percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_71percent_75percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_76percent_80percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_81percent_85percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_86percent_90percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_91percent_95percent",                   precision: 5,  scale: 2
        t.decimal "pcx_aftertax_max_percent_96percent_100percent",                  precision: 5,  scale: 2
        t.decimal "pcx_rolloverin_percent_no",                                      precision: 5,  scale: 2
        t.decimal "pcx_rolloverin_percent_yes",                                     precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_formula_percent_discretionary",            precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_formula_percentage_fixed",                 precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_immediate",                precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_2_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_3_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_4_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_5_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_graded_6_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_1_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_2_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_cliff_3_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_vesting_percent_other",                    precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_no",                           precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_eoy_percent_yes",                          precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_no",                      precision: 5,  scale: 2
        t.decimal "pcx_employer_matching_1000_hrs_percent_yes",                     precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_percent_no",                          precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_percent_yes",                         precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_immediate",           precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_2_years",      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_3_years",      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_4_years",      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_5_years",      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_graded_6_years",      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_1_yrs",         precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_2_yrs",         precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_cliff_3_yrs",         precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_vesting_percent_other",               precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_no",                      precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_eoy_percent_yes",                     precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_no",                 precision: 5,  scale: 2
        t.decimal "pcx_employer_discretionary_1000_hrs_percent_yes",                precision: 5,  scale: 2
        t.decimal "pcx_employer_required_none",                                     precision: 5,  scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_std",        precision: 5,  scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qnec_other",      precision: 5,  scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_std",        precision: 5,  scale: 2
        t.decimal "pcx_employer_required_safe_harbor_type_percent_qmac_other",      precision: 5,  scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent",                  precision: 5,  scale: 2
        t.decimal "pcx_employer_required_percent_straightpercent_amtcap",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_percent_integrated",                       precision: 5,  scale: 2
        t.decimal "pcx_employer_required_percent_pointsformula",                    precision: 5,  scale: 2
        t.decimal "pcx_employer_required_percent_other",                            precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_immediate",                precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_2_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_3_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_4_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_5_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_graded_6_years",           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_1_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_2_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_cliff_3_yrs",              precision: 5,  scale: 2
        t.decimal "pcx_employer_required_vesting_percent_other",                    precision: 5,  scale: 2
        t.decimal "pcx_employer_required_eoy_percent_no",                           precision: 5,  scale: 2
        t.decimal "pcx_employer_required_eoy_percent_yes",                          precision: 5,  scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_no",                      precision: 5,  scale: 2
        t.decimal "pcx_employer_required_1000_hrs_percent_yes",                     precision: 5,  scale: 2
        t.decimal "pcx_target_date_funds_no",                                       precision: 5,  scale: 2
        t.decimal "pcx_target_date_funds_yes",                                      precision: 5,  scale: 2
        t.decimal "pcx_risk_based_funds_no",                                        precision: 5,  scale: 2
        t.decimal "pcx_risk_based_funds_yes",                                       precision: 5,  scale: 2
        t.decimal "pcx_model_portfolios_from_core_no",                              precision: 5,  scale: 2
        t.decimal "pcx_model_portfolios_from_core_yes",                             precision: 5,  scale: 2
        t.decimal "pcx_managed_account_from_core_no",                               precision: 5,  scale: 2
        t.decimal "pcx_managed_account_from_core_yes",                              precision: 5,  scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_no",                          precision: 5,  scale: 2
        t.decimal "pcx_default_all_ees_qdia_from_core_yes",                         precision: 5,  scale: 2
        t.integer "pcx_number_of_core_options_from_core_no"
        t.integer "pcx_number_of_core_options_from_core_yes"
        t.integer "pcx_number_of_core_assetclasses_from_core_no"
        t.integer "pcx_number_of_core_assetclasses_from_core_yes"
        t.decimal "pcx_auto_rebalance_percent_no",                                  precision: 5,  scale: 2
        t.decimal "pcx_auto_rebalance_percent_yes",                                 precision: 5,  scale: 2
        t.decimal "pcx_sda_percent_no",                                             precision: 5,  scale: 2
        t.decimal "pcx_sda_percent_yes",                                            precision: 5,  scale: 2
        t.decimal "pcx_company_stock_percent_no",                                   precision: 5,  scale: 2
        t.decimal "pcx_company_stock_percent_yes",                                  precision: 5,  scale: 2
        t.decimal "pcx_loans_allowed_percent_no",                                   precision: 5,  scale: 2
        t.decimal "pcx_loans_allowed_percent_yes",                                  precision: 5,  scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_only",                    precision: 5,  scale: 2
        t.decimal "pcx_loan_types_allowed_percent_residential_only",                precision: 5,  scale: 2
        t.decimal "pcx_loan_types_allowed_percent_general_and_residential",         precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_1",                                precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_2",                                precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_3",                                precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_4",                                precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_5",                                precision: 5,  scale: 2
        t.decimal "pcx_max_loans_allowed_percent_gt5",                              precision: 5,  scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_no",                            precision: 5,  scale: 2
        t.decimal "pcx_age_59_5_withdrawals_percent_yes",                           precision: 5,  scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_no",                            precision: 5,  scale: 2
        t.decimal "pcx_hardship_withdrawals_percent_yes",                           precision: 5,  scale: 2
        t.decimal "pcx_hardship_loans_percent_no",                                  precision: 5,  scale: 2
        t.decimal "pcx_hardship_loans_percent_yes",                                 precision: 5,  scale: 2
        t.decimal "pcx_hardship_withdrawals_and_hardship_loans_percent_yes",        precision: 5,  scale: 2
        t.decimal "pcx_installment_payments_percent_no",                            precision: 5,  scale: 2
        t.decimal "pcx_installment_payments_percent_yes",                           precision: 5,  scale: 2
        t.decimal "pcx_annuities_percent_no",                                       precision: 5,  scale: 2
        t.decimal "pcx_annuities_percent_yes",                                      precision: 5,  scale: 2
        t.decimal "pcx_cash_out_percent_none",                                      precision: 5,  scale: 2
        t.decimal "pcx_cash_out_percent_amt1000",                                   precision: 5,  scale: 2
        t.decimal "pcx_cash_out_percent_amt5000",                                   precision: 5,  scale: 2
        t.decimal "pcx_cash_out_percent_other",                                     precision: 5,  scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_no",                         precision: 5,  scale: 2
        t.decimal "pcx_lifetime_annuity_option_percent_yes",                        precision: 5,  scale: 2
        t.decimal "pcx_lifetime_income_service_no",                                 precision: 5,  scale: 2
        t.decimal "pcx_lifetime_income_service_yes",                                precision: 5,  scale: 2
        t.decimal "pcx_valuation_frequency_percent_daily",                          precision: 5,  scale: 2
        t.decimal "pcx_valuation_frequency_percent_annual",                         precision: 5,  scale: 2
        t.decimal "pcx_valuation_frequency_percent_semi_annual",                    precision: 5,  scale: 2
        t.decimal "pcx_valuation_frequency_percent_quarterly",                      precision: 5,  scale: 2
        t.decimal "pcx_valuation_frequency_percent_monthly",                        precision: 5,  scale: 2
      end

      create_table "bmg_rk_plans", force: true do |t|
        t.integer "bmg_rk_master_id"
        t.date    "vintage_date"
        t.integer "plan_id"
        t.integer "total_participants"
        t.integer "total_assets"
        t.integer "average_balance"
        t.integer "total_rk_fees"
        t.integer "total_rk_fees_per_participant"
      end

      create_table "bmg_tpa_investment_fees", force: true do |t|
        t.integer "market_segment_id"
        t.integer "fbi_asset_class_id"
        t.integer "investment_strategy_id"
        t.decimal "to_tpa_25th",            precision: 8, scale: 5
        t.decimal "to_tpa_50th",            precision: 8, scale: 5
        t.decimal "to_tpa_75th",            precision: 8, scale: 5
      end

      create_table "bmg_tpa_masters", force: true do |t|
        t.date    "vintage_date"
        t.integer "tpa_bmg_assets_low"
        t.integer "tpa_bmg_assets_50th"
        t.integer "tpa_bmg_assets_high"
        t.integer "tpa_bmg_participants_low"
        t.integer "tpa_bmg_participants_high"
        t.integer "tpa_bmg_participants_avgbalance_low"
        t.integer "tpa_bmg_participants_avgbalance_high"
        t.decimal "tpa_bmg_correlation_coefficient",                  precision: 6,  scale: 3
        t.decimal "tpa_bmg_regressionline_slope_value",               precision: 8,  scale: 5
        t.decimal "tpa_bmg_regressionline_constant_value",            precision: 7,  scale: 2
        t.integer "tpa_total_plans"
        t.integer "tpa_planstype_401k"
        t.integer "tpa_planstype_403b"
        t.integer "tpa_planstype_other"
        t.integer "tpa_plans_insco"
        t.integer "tpa_plans_mutualfunds"
        t.integer "tpa_plans_bank"
        t.integer "tpa_plans_tpa"
        t.integer "tpa_plans_other"
        t.integer "tpa_total_tpas"
        t.integer "tpa_rkbusinessmodel_insco"
        t.integer "tpa_rkbusinessmodel_mutualfunds"
        t.integer "tpa_rkbusinessmodel_bank"
        t.integer "tpa_rkbusinessmodel_tpa"
        t.integer "tpa_rkbusinessmodel_other"
        t.decimal "tpa_totalfees_dollars_5th",                        precision: 12, scale: 2
        t.decimal "tpa_totalfees_dollars_25th",                       precision: 12, scale: 2
        t.decimal "tpa_totalfees_dollars_50th",                       precision: 12, scale: 2
        t.decimal "tpa_totalfees_dollars_75th",                       precision: 12, scale: 2
        t.decimal "tpa_totalfees_dollars_95th",                       precision: 12, scale: 2
        t.decimal "tpa_totalfees_bps_5th",                            precision: 7,  scale: 4
        t.decimal "tpa_totalfees_bps_25th",                           precision: 7,  scale: 4
        t.decimal "tpa_totalfees_bps_50th",                           precision: 7,  scale: 4
        t.decimal "tpa_totalfees_bps_75th",                           precision: 7,  scale: 4
        t.decimal "tpa_totalfees_bps_95th",                           precision: 7,  scale: 4
        t.decimal "tpa_totalfees_perpart_5th",                        precision: 9,  scale: 2
        t.decimal "tpa_totalfees_perpart_25th",                       precision: 9,  scale: 2
        t.decimal "tpa_totalfees_perpart_50th",                       precision: 9,  scale: 2
        t.decimal "tpa_totalfees_perpart_75th",                       precision: 9,  scale: 2
        t.decimal "tpa_totalfees_perpart_95th",                       precision: 9,  scale: 2
        t.decimal "tpa_loanorigination_percent_plans_with_fee",       precision: 5,  scale: 2
        t.decimal "tpa_loanorigination_25th",                         precision: 7,  scale: 2
        t.decimal "tpa_loanorigination_50th",                         precision: 7,  scale: 2
        t.decimal "tpa_loanorigination_75th",                         precision: 7,  scale: 2
        t.decimal "tpa_hardshipapproval_percent_plans_with_fee",      precision: 5,  scale: 2
        t.decimal "tpa_hardshipapproval_25th",                        precision: 7,  scale: 2
        t.decimal "tpa_hardshipapproval_50th",                        precision: 7,  scale: 2
        t.decimal "tpa_hardshipapproval_75th",                        precision: 7,  scale: 2
        t.decimal "tpa_qdroapproval_percent_plans_with_fee",          precision: 5,  scale: 2
        t.decimal "tpa_qdroapproval_25th",                            precision: 7,  scale: 2
        t.decimal "tpa_qdroapproval_50th",                            precision: 7,  scale: 2
        t.decimal "tpa_qdroapproval_75th",                            precision: 7,  scale: 2
        t.decimal "tpa_periodicpayment_setup_percent_plans_with_fee", precision: 5,  scale: 2
        t.decimal "tpa_periodicpayment_setup_25th",                   precision: 7,  scale: 2
        t.decimal "tpa_periodicpayment_setup_50th",                   precision: 7,  scale: 2
        t.decimal "tpa_periodicpayment_setup_75th",                   precision: 7,  scale: 2
      end

      create_table "bmg_tpa_plans", force: true do |t|
        t.integer "bmg_tpa_master_id"
        t.date    "vintage_date"
        t.integer "plan_id"
        t.integer "total_participants"
        t.integer "total_assets"
        t.integer "average_balance"
        t.integer "total_tpa_fees"
        t.integer "total_tpa_fees_per_participant"
      end

      create_table "brokerage_platform_lists", force: true do |t|
        t.string  "name",         limit: 150
        t.string  "address_1",    limit: 100
        t.string  "address_2",    limit: 50
        t.string  "city",         limit: 100
        t.integer "state_id"
        t.integer "zip_code_id"
        t.string  "phone_number", limit: 20
        t.string  "website"
      end

      create_table "business_models", force: true do |t|
        t.integer "duty_id"
        t.string  "name",    limit: 32
      end

      create_table "clients", force: true do |t|
        t.integer  "company_id"
        t.string   "referred_by",                                      limit: 150
        t.date     "disclosure_subscription_date"
        t.date     "dc_benchmarking_v2_subscription_date"
        t.date     "benchmarking_subscription_date"
        t.date     "db_benchmarking_subscription_date"
        t.date     "retirement_outcomes_evaluation_subscription_date"
        t.date     "plan_profile_subscription_date"
        t.date     "form_5500_provider_subscription_date"
        t.date     "disclosure_expiration_date"
        t.date     "dc_benchmarking_v2_expiration_date"
        t.date     "benchmarking_expiration_date"
        t.date     "db_benchmarking_expiration_date"
        t.date     "retirement_outcomes_evaluation_expiration_date"
        t.date     "plan_profile_expiration_date"
        t.date     "form_5500_provider_expiration_date"
        t.integer  "data_and_report_cycle_id"
        t.integer  "cover_page_logo_location"
        t.boolean  "is_cover_page_logo_overridden_by_advisor"
        t.text     "cover_page_info"
        t.boolean  "is_cover_page_info_overridden_by_advisor"
        t.text     "cover_page_disclaimer"
        t.text     "benchmarking_page_bottom_disclaimer"
        t.text     "benchmarking_back_page_disclosures"
        t.text     "roe_page_bottom_disclaimer"
        t.text     "roe_back_page_disclosures"
        t.text     "plan_profile_page_bottom_disclaimer"
        t.text     "plan_profile_back_page_disclosures"
        t.text     "form_5500_output_page_bottom_disclaimer"
        t.text     "form_5500_output_roe_back_page_disclosures"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "cola_by_fips", force: true do |t|
        t.integer "fips_code"
        t.decimal "FIPS_Code_COLA",             precision: 6, scale: 1
        t.string  "FIPS_County",    limit: 100
        t.integer "calendar_year"
      end

      create_table "companies", force: true do |t|
        t.integer  "enterprise_id"
        t.integer  "rk_tpa_type_id"
        t.integer  "business_model_id"
        t.integer  "finra_code"
        t.integer  "ein"
        t.integer  "duns"
        t.string   "name",                   limit: 150
        t.string   "address_1",              limit: 100
        t.string   "address_2",              limit: 50
        t.string   "city",                   limit: 100
        t.integer  "state_id"
        t.integer  "zip_code_id"
        t.string   "phone_number",           limit: 32
        t.string   "website"
        t.boolean  "is_5500"
        t.integer  "naics_6_digits"
        t.string   "customer_identifier",    limit: 150
        t.integer  "internet_capability"
        t.boolean  "needs_review"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.boolean  "has_instantiated_plans"
      end

      add_index "companies", ["ein"], name: "index_companies_on_ein", unique: true, using: :btree
      add_index "companies", ["name"], name: "name_ix", using: :btree

      create_table "custodians", force: true do |t|
        t.string   "name"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "data_and_report_cycles", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "disclosure408_b2_report_types", force: true do |t|
        t.string "name", limit: 24
      end

      create_table "disclosure408_b2_reports", force: true do |t|
        t.integer "report_id"
        t.integer "user_id_payor"
        t.integer "user_id_primary_sponsor_contact"
        t.integer "disclosure_type_id"
        t.date    "disclosure_initiated_date"
        t.date    "actual_disclosure_delivery_date"
        t.integer "disclosure_binary_locator"
        t.date    "disclosure_data_set_date"
        t.string  "disclosure_data_set_string",      limit: 1
      end

      create_table "disclosure_deliveries", force: true do |t|
        t.string   "email_to"
        t.string   "email_cc"
        t.string   "email_bcc"
        t.string   "email_subject"
        t.string   "email_attachment"
        t.text     "email_body"
        t.string   "email_status",     default: "New"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.integer  "disclosure_id"
        t.boolean  "email_sent",       default: false
      end

      create_table "disclosure_fee_values", force: true do |t|
        t.decimal  "amount",            precision: 10, scale: 3
        t.string   "amount_type"
        t.integer  "frequency"
        t.integer  "timing"
        t.integer  "payor"
        t.datetime "effective_date"
        t.integer  "plan_service_id"
        t.integer  "disclosure_id"
        t.integer  "disclosure_fee_id"
      end

      create_table "disclosure_fees", force: true do |t|
        t.integer "order"
        t.string  "name"
        t.string  "amount_type"
        t.boolean "effective_date"
        t.string  "title"
        t.text    "description"
        t.string  "frequency_title"
        t.string  "fee_type"
      end

      create_table "disclosure_meetings", force: true do |t|
        t.integer  "disclosure_id"
        t.integer  "number_of_meetings"
        t.integer  "annual_hours"
        t.integer  "travel_days"
        t.integer  "miles_driven"
        t.decimal  "airfare",            precision: 10, scale: 0
        t.decimal  "hotel",              precision: 10, scale: 0
        t.boolean  "billed_separately"
        t.integer  "purpose"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "disclosure_types", force: true do |t|
        t.string  "service_provider_type"
        t.string  "name"
        t.string  "display_name"
        t.boolean "disabled"
        t.boolean "investments"
      end

      create_table "disclosures", force: true do |t|
        t.boolean  "include_advisor_fees"
        t.boolean  "bdria_payout"
        t.integer  "bdria_payout_percentage"
        t.string   "plan_name"
        t.decimal  "plan_assets",                  precision: 16, scale: 3
        t.decimal  "plan_assets_under_advisement", precision: 16, scale: 3
        t.integer  "plan_participants"
        t.string   "plan_custodian"
        t.boolean  "plan_has_minimum_fee"
        t.decimal  "plan_minimum_fee",             precision: 8,  scale: 2
        t.boolean  "plan_minimum_fee_dollar"
        t.boolean  "plan_has_maximum_fee"
        t.decimal  "plan_maximum_fee",             precision: 8,  scale: 2
        t.boolean  "plan_maximum_fee_dollar"
        t.string   "rpf_name"
        t.string   "rpf_email"
        t.string   "rpf_address_line_1"
        t.string   "rpf_address_line_2"
        t.string   "rpf_address_zip_code"
        t.string   "rpf_address_city"
        t.string   "rpf_address_state"
        t.boolean  "use_standard_clause"
        t.text     "custom_clause"
        t.integer  "disclosure_type_id"
        t.boolean  "include_frequency"
        t.integer  "recordkeeper_id"
        t.integer  "custodian_id"
        t.boolean  "make_formal_referral"
        t.integer  "service_provider_type"
        t.string   "service_provider_name"
        t.integer  "user_id"
        t.integer  "alder_plan_id"
        t.datetime "created_at",                                            null: false
        t.datetime "updated_at",                                            null: false
        t.integer  "split_code_id"
        t.boolean  "fees_effective_immediately"
        t.integer  "fee_template_id"
        t.integer  "plan_fiduciary_status_id"
        t.string   "company_name"
        t.string   "enterprise_name"
        t.string   "short_name"
      end

      create_table "document_type_categories", force: true do |t|
        t.string "name", limit: 16
      end

      create_table "document_type_masters", force: true do |t|
        t.string  "document_type_master_code", limit: 4
        t.integer "document_type_category_id"
        t.string  "document_type",             limit: 30
      end

      create_table "duties", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "enterprises", force: true do |t|
        t.integer "enterprise_id_legacy"
        t.integer "dun_and_bradstreet_number"
        t.string  "name",                      limit: 150
        t.integer "company_id"
      end

      create_table "extract_advisor_key_maps", force: true do |t|
        t.integer "user_id"
        t.integer "client_id"
        t.string  "recordkeeper_foreign_key", limit: 64
      end

      create_table "fbi_asset_classes", force: true do |t|
        t.integer "fbi_asset_class_code"
        t.string  "asset_class_name",               limit: 30
        t.integer "applicable_tier_of_3_tier_menu"
        t.integer "risk_based_sort_order"
        t.string  "category_investment_structure",  limit: 100
      end

      create_table "fee_templates", force: true do |t|
        t.string   "name"
        t.boolean  "transfer_plan"
        t.decimal  "transfer_plan_amount",             precision: 16, scale: 3
        t.boolean  "transfer_plan_amount_dollar"
        t.integer  "transfer_plan_frequency"
        t.integer  "transfer_plan_timing"
        t.integer  "transfer_plan_payor"
        t.boolean  "new_contributions"
        t.datetime "new_contributions_effective_date"
        t.decimal  "new_contributions_amount",         precision: 16, scale: 3
        t.boolean  "new_contributions_amount_dollar"
        t.integer  "new_contributions_frequency"
        t.integer  "new_contributions_timing"
        t.integer  "new_contributions_payor"
        t.boolean  "assets"
        t.datetime "assets_effective_date"
        t.decimal  "assets_amount",                    precision: 16, scale: 3
        t.boolean  "assets_amount_dollar"
        t.integer  "assets_frequency"
        t.integer  "assets_timing"
        t.integer  "assets_payor"
        t.boolean  "twelveb1"
        t.datetime "twelveb1_effective_date"
        t.decimal  "twelveb1_amount",                  precision: 10, scale: 0
        t.boolean  "twelveb1_amount_dollar"
        t.integer  "twelveb1_frequency"
        t.integer  "twelveb1_timing"
        t.integer  "twelveb1_payor"
        t.boolean  "flat"
        t.decimal  "flat_amount",                      precision: 16, scale: 3
        t.boolean  "flat_amount_dollar"
        t.integer  "flat_frequency"
        t.integer  "flat_timing"
        t.integer  "flat_payor"
        t.boolean  "hourly"
        t.decimal  "hourly_amount",                    precision: 16, scale: 3
        t.integer  "hourly_frequency"
        t.integer  "hourly_timing"
        t.integer  "hourly_payor"
        t.boolean  "other"
        t.string   "other_description"
        t.decimal  "other_amount",                     precision: 16, scale: 3
        t.boolean  "other_amount_dollar"
        t.integer  "other_frequency"
        t.integer  "other_timing"
        t.integer  "other_payor"
        t.boolean  "tiered"
        t.boolean  "tiered_incremental"
        t.decimal  "tiered_amount",                    precision: 16, scale: 3
        t.boolean  "tiered_amount_dollar"
        t.integer  "tiered_frequency"
        t.integer  "tiered_timing"
        t.integer  "tiered_payor"
        t.datetime "created_at",                                                null: false
        t.datetime "updated_at",                                                null: false
        t.boolean  "effective_immediately"
        t.decimal  "hourly_rate",                      precision: 16, scale: 3
        t.boolean  "tiered_fee_dollar"
      end

      create_table "fee_tiers", force: true do |t|
        t.integer  "fee_template_id"
        t.integer  "number"
        t.decimal  "end_point",       precision: 16, scale: 3
        t.decimal  "amount",          precision: 16, scale: 3
        t.datetime "created_at",                               null: false
        t.datetime "updated_at",                               null: false
        t.integer  "disclosure_id"
      end

      create_table "fee_types", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "fiduciary_status_types", force: true do |t|
        t.string "name", limit: 16
      end

      create_table "form5500_pension_benefit_codes", force: true do |t|
        t.string "pension_benefit_code", limit: 2
        t.string "description",          limit: 800
      end

      create_table "form5500_schedule_c_service_providers", force: true do |t|
        t.string "dept_of_labor_pension_benefit_code", limit: 2
        t.string "description",                        limit: 200
      end

      create_table "form5500s", force: true do |t|
        t.integer "ein_plan_code",                             limit: 8
        t.integer "company_id"
        t.integer "plan_number_3_digit"
        t.string  "plan_name",                                 limit: 200
        t.date    "plan_effective_date"
        t.date    "plan_year_ending"
        t.integer "number_of_participants_with_acct_balances"
        t.integer "schedule_h_total_assets",                   limit: 8
      end

      add_index "form5500s", ["company_id"], name: "company_id_ix", using: :btree
      add_index "form5500s", ["plan_name"], name: "plan_name_ix", using: :btree

      create_table "form5500s_form5500_pension_benefit_codes", id: false, force: true do |t|
        t.integer "Form5500_id"
        t.integer "Form5500PensionBenefitCode_id"
      end

      create_table "form5500s_form5500_schedule_c_service_providers", id: false, force: true do |t|
        t.integer "Form5500_id"
        t.integer "Form5500ScheduleCServiceProvider_id"
      end

      create_table "general_accounts", force: true do |t|
        t.integer "recordkeeper_product_guide_id"
        t.integer "client_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.decimal "current_rate_new_money",                            precision: 9, scale: 5
        t.decimal "minimum_rate_new_money",                            precision: 9, scale: 5
        t.decimal "blended_minimum_rate",                              precision: 9, scale: 5
        t.decimal "blended_1yr",                                       precision: 9, scale: 5
        t.decimal "blended_3yr",                                       precision: 9, scale: 5
        t.decimal "blended_5yr",                                       precision: 9, scale: 5
        t.integer "percent_current_rate_reset"
        t.integer "percent_minimum_rate_reset"
        t.integer "percent_blended_rate_reset"
        t.string  "credit_quality_guarantor_agency",        limit: 1
        t.string  "credit_quality_guarantor_agency_rating", limit: 10
        t.integer "mva_number_of_months"
      end

      create_table "general_accounts_templates", force: true do |t|
        t.integer "client_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.decimal "currentrate_newmoney",     precision: 9, scale: 5
        t.decimal "minimumrate_newmoney",     precision: 9, scale: 5
        t.decimal "blendedminimumrate",       precision: 9, scale: 5
        t.decimal "blended1yr",               precision: 9, scale: 5
        t.decimal "blended3yr",               precision: 9, scale: 5
        t.decimal "blended5yr",               precision: 9, scale: 5
        t.integer "percent_currentratereset"
        t.integer "percent_minimumratereset"
        t.integer "percent_blendedratereset"
        t.integer "rating_agency"
        t.integer "rating_value"
        t.integer "mva_number_of_months"
      end

      create_table "instrument_types", force: true do |t|
        t.string "instrument_type_code"
        t.string "instrument_description", limit: 20
      end

      create_table "intervals", force: true do |t|
        t.string "name"
      end

      create_table "investment_data_providers", force: true do |t|
        t.integer "investment_data_provider_code"
        t.integer "instrument_type_id"
        t.integer "enterprise_id"
        t.integer "rk_tpa_list_id"
        t.string  "investment_data_provider_name", limit: 50
      end

      create_table "investment_lists", force: true do |t|
        t.integer "security_id_legacy"
        t.integer "investment_data_provider_id"
        t.date    "as_of"
        t.string  "cusip",                                  limit: 13
        t.string  "ticker",                                 limit: 15
        t.string  "morningstar_investment_vehicle_code",    limit: 15
        t.string  "provider_security_code",                 limit: 30
        t.string  "name",                                   limit: 96
        t.date    "inception_date"
        t.date    "prospectus_date"
        t.string  "fund_family_code",                       limit: 10
        t.string  "fund_family_name",                       limit: 50
        t.integer "assets"
        t.string  "website_address",                        limit: 256
        t.integer "instrument_type_id"
        t.string  "asset_category",                         limit: 32
        t.string  "morningstar_category",                   limit: 32
        t.integer "fbi_asset_class_id"
        t.boolean "fbi_auto_diversifed_indicator"
        t.boolean "active_passive_indicator"
        t.string  "share_class_name",                       limit: 16
        t.string  "share_class_code",                       limit: 10
        t.boolean "fbi_index_fund_indicator"
        t.boolean "fbi_index_neither_fund_indicator"
        t.decimal "total_expense_ratio",                                precision: 5, scale: 2
        t.decimal "net_expense_ratio",                                  precision: 5, scale: 2
        t.decimal "actual_management_fee",                              precision: 6, scale: 4
        t.decimal "12b_1_fee",                                          precision: 4, scale: 2
        t.decimal "front_load",                                         precision: 5, scale: 2
        t.decimal "deferred_load",                                      precision: 4, scale: 2
        t.decimal "redemption_fee",                                     precision: 4, scale: 2
        t.integer "redemption_days"
        t.integer "redemption_time_period"
        t.date    "month_end_date"
        t.decimal "trailing_total_returns_1_year_returns",              precision: 5, scale: 2
        t.decimal "trailing_total_returns_3_year_returns",              precision: 5, scale: 2
        t.decimal "trailing_total_returns_5_year_returns",              precision: 5, scale: 2
        t.decimal "trailing_total_returns_10_year_returns",             precision: 5, scale: 2
      end

      create_table "investment_strategies", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "investment_vehicles", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "investments", force: true do |t|
        t.integer "disclosure_id"
        t.integer "ms_fund_id"
        t.integer "assets"
      end

      create_table "managed_accounts", force: true do |t|
        t.integer "recordkeeper_product_guide_id"
        t.integer "client_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.integer "fiduciary_status_id"
        t.integer "ma_employer_annual_fee"
        t.integer "ma_participant_minimum_fee"
        t.decimal "ma_fee_for_10k",                            precision: 7, scale: 4
        t.decimal "ma_fee_for_25k",                            precision: 7, scale: 4
        t.decimal "ma_fee_for_50k",                            precision: 7, scale: 4
        t.decimal "ma_fee_for_100k",                           precision: 7, scale: 4
        t.decimal "ma_fee_for_250k",                           precision: 7, scale: 4
        t.decimal "ma_fee_for_500k",                           precision: 7, scale: 4
        t.string  "ma_service_provider",           limit: 100
      end

      create_table "managed_accounts_templates", force: true do |t|
        t.integer "client_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.integer "fiduciary_status_id"
        t.integer "ma_employer_annual_fee"
        t.integer "ma_participant_minimum_fee"
        t.decimal "ma_fee_for_10k",                         precision: 7, scale: 4
        t.decimal "ma_fee_for_25k",                         precision: 7, scale: 4
        t.decimal "ma_fee_for_50k",                         precision: 7, scale: 4
        t.decimal "ma_fee_for_100k",                        precision: 7, scale: 4
        t.decimal "ma_fee_for_250k",                        precision: 7, scale: 4
        t.decimal "ma_fee_for_500k",                        precision: 7, scale: 4
        t.string  "ma_service_provider",        limit: 100
      end

      create_table "market_segments", force: true do |t|
        t.integer "duty_id"
        t.string  "description",  limit: 20
        t.integer "start_assets", limit: 8
        t.integer "end_assets",   limit: 8
      end

      create_table "matching_methods", force: true do |t|
        t.integer "bmg_employer_contribution_id"
        t.integer "bmg_contribution_type_id"
        t.decimal "contribution_percent_5th",                      precision: 7, scale: 4
        t.decimal "contribution_percent_25th",                     precision: 7, scale: 4
        t.decimal "contribution_percent_50th",                     precision: 7, scale: 4
        t.decimal "contribution_percent_75th",                     precision: 7, scale: 4
        t.decimal "contribution_percent_95th",                     precision: 7, scale: 4
        t.decimal "percent_plans_no_dollar_limit_percent",         precision: 5, scale: 2
        t.decimal "percent_plans_with_dollar_limit_percent",       precision: 5, scale: 2
        t.integer "dollar_limitation_5th"
        t.integer "dollar_limitation_25th"
        t.integer "dollar_limitation_50th"
        t.integer "dollar_limitation_75th"
        t.integer "dollar_limitation_95th"
        t.decimal "percent_plans_vesting_immediate",               precision: 5, scale: 2
        t.decimal "percent_plans_vesting_graded_2_years",          precision: 5, scale: 2
        t.decimal "percent_plans_vesting_graded_3_years",          precision: 5, scale: 2
        t.decimal "percent_plans_vesting_graded_4_years",          precision: 5, scale: 2
        t.decimal "percent_plans_vesting_graded_5_years",          precision: 5, scale: 2
        t.decimal "percent_plans_vesting_graded_6_years",          precision: 5, scale: 2
        t.decimal "percent_plans_vesting_cliff_1_yrs",             precision: 5, scale: 2
        t.decimal "percent_plans_vesting_cliff_2_yrs",             precision: 5, scale: 2
        t.decimal "percent_plans_vesting_cliff_3_yrs",             precision: 5, scale: 2
        t.decimal "percent_plans_vesting_other",                   precision: 5, scale: 2
        t.decimal "percent_plans_eoy_requirement_percent_no",      precision: 5, scale: 2
        t.decimal "percent_plans_eoy_requirement_percent_yes",     precision: 5, scale: 2
        t.decimal "percent_plans_1000hrs_requirement_percent_no",  precision: 5, scale: 2
        t.decimal "percent_plans_1000hrs_requirement_percent_yes", precision: 5, scale: 2
      end

      create_table "model_strategies", force: true do |t|
        t.string "name", limit: 32
      end

      create_table "ms_funds", force: true do |t|
        t.string   "name",               limit: 100
        t.string   "ticker",             limit: 10
        t.float    "net_expense_ratio"
        t.float    "average_net_assets"
        t.datetime "created_at",                                             null: false
        t.datetime "updated_at",                                             null: false
        t.decimal  "actual12B1",                     precision: 8, scale: 5
      end

      create_table "naics2_digit_codes", force: true do |t|
        t.integer "code"
        t.string  "description", limit: 100
      end

      create_table "naics2_digit_comp_data", force: true do |t|
        t.integer "naics_2_digit_code"
        t.integer "naics_2_digit_id_median_comp"
        t.integer "naics_2_digit_id_median_SalaryWages"
        t.decimal "naics_2_digit_id_avg_turnover",       precision: 4, scale: 2
        t.integer "calendar_year"
      end

      create_table "naics3_digit_codes", force: true do |t|
        t.integer "naics_3_digit_code"
        t.string  "naics_3_digit_description", limit: 100
      end

      create_table "naics3_digit_comp_data", force: true do |t|
        t.integer "naics_3_digit_code"
        t.integer "naics_3_digit_id_median_comp"
        t.decimal "naics_3_digit_id_avg_turnover", precision: 4, scale: 2
        t.integer "calendar_year"
      end

      create_table "other_fees", force: true do |t|
        t.integer "recordkeeper_product_guide_id"
        t.string  "description",                   limit: 60
        t.integer "type"
        t.integer "amount_amt"
        t.decimal "amount_bps",                               precision: 8, scale: 5
        t.integer "amount_bps_assets"
        t.integer "payment_term_id"
        t.date    "payment_date"
        t.integer "volumes"
        t.integer "recipient_type_id"
        t.string  "recipient_name",                limit: 60
        t.boolean "is_recipient_affiliated"
        t.integer "payor_type_id"
        t.string  "payor_name",                    limit: 60
      end

      create_table "participant_activity_fee_templates", force: true do |t|
        t.integer "client_id"
        t.integer "duty_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.integer "annual_per_participant_advice_fee"
        t.integer "loan_origination_fee"
        t.integer "loan_maintenance_fee"
        t.integer "hardship_approval_fee"
        t.integer "qdro_approval_fee"
        t.integer "qdro_processing_fee"
        t.integer "periodic_payment_setup_fee"
        t.integer "periodic_payment_processing_fee"
        t.integer "nonperiodic_payment_setup_fee"
        t.integer "nonperiodic_payment_processing_fee"
      end

      create_table "participant_activity_fees", force: true do |t|
        t.integer "recordkeeper_product_guide_id"
        t.integer "asset_beginning"
        t.integer "asset_end"
        t.integer "participant_beginning"
        t.integer "participant_end"
        t.integer "annual_per_participant_advice_fee"
        t.integer "loan_origination_fee"
        t.integer "loan_maintenance_fee"
        t.integer "hardship_approval_fee"
        t.integer "qdro_approval_fee"
        t.integer "qdro_processing_fee"
        t.integer "periodic_payment_setup_fee"
        t.integer "periodic_payment_processing_fee"
        t.integer "nonperiodic_payment_setup_fee"
        t.integer "nonperiodic_payment_processing_fee"
      end

      create_table "payment_terms", force: true do |t|
        t.string "name", limit: 16
      end

      create_table "payor_types", force: true do |t|
        t.string "code", limit: 1
        t.string "name", limit: 32
      end

      create_table "people", force: true do |t|
        t.integer  "company_id"
        t.string   "first_name",        limit: 128
        t.string   "middle_name",       limit: 128
        t.string   "last_name",         limit: 128
        t.string   "address_1",         limit: 200
        t.string   "address_2",         limit: 100
        t.string   "city",              limit: 100
        t.integer  "state_id"
        t.integer  "zip_code_id"
        t.string   "title",             limit: 150
        t.string   "department",        limit: 150
        t.string   "person_email",      limit: 150
        t.string   "work_phone",        limit: 20
        t.string   "cell_phone",        limit: 20
        t.string   "home_phone",        limit: 20
        t.string   "fax",               limit: 20
        t.integer  "user_id_assistant"
        t.date     "birth_date"
        t.boolean  "needs_review"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "principal_exams", force: true do |t|
        t.integer "principal_exam_code"
        t.string  "principal_exam_description", limit: 100
      end

      create_table "product_guides", force: true do |t|
        t.integer  "plan_id"
        t.string   "name",        limit: 30
        t.string   "description", limit: 150
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      create_table "qdia_investments", force: true do |t|
        t.integer "investment_list_id"
        t.integer "fbi_asset_class_id"
        t.decimal "allocation",         precision: 5, scale: 2
      end

      create_table "rating_agencies", force: true do |t|
        t.string "name", limit: 32
      end


      add_index "zip_codes", ["zip_code"], name: "index_zip_codes_on_zip_code", unique: true, using: :btree

    end

    expect(result.name).to eq 'rating_agencies'
    expect(described_class.search_cache('rating_agencies').name).to eq 'rating_agencies'
    expect(described_class.search_cache('advisor_fee_groups')).to eq nil

  end

end