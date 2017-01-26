# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170125195323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "venue"
    t.string   "address_lines"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "location_id"
    t.string   "status"
    t.boolean  "primary"
    t.string   "address_type"
    t.string   "occupation"
    t.integer  "person_id"
    t.string   "type"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "location_accuracy"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["location_id"], name: "index_addresses_on_location_id", using: :btree
    t.index ["person_id"], name: "index_addresses_on_person_id", using: :btree
  end

  create_table "advocacy_campaigns", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "targets"
    t.string   "browser_url"
    t.string   "featured_image_url"
    t.integer  "total_outreaches"
    t.string   "type"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["creator_id"], name: "index_advocacy_campaigns_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_advocacy_campaigns_on_modified_by_id", using: :btree
  end

  create_table "advocacy_campaigns_groups", id: false, force: :cascade do |t|
    t.integer "advocacy_campaign_id"
    t.integer "group_id"
    t.index ["advocacy_campaign_id"], name: "index_advocacy_campaigns_groups_on_advocacy_campaign_id", using: :btree
    t.index ["group_id"], name: "index_advocacy_campaigns_groups_on_group_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.datetime "action_date"
    t.string   "value"
    t.integer  "responses_id"
    t.integer  "question_id"
    t.integer  "canvass_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["canvass_id"], name: "index_answers_on_canvass_id", using: :btree
    t.index ["question_id"], name: "index_answers_on_question_id", using: :btree
    t.index ["responses_id"], name: "index_answers_on_responses_id", using: :btree
  end

  create_table "attendances", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.string   "status"
    t.boolean  "attended"
    t.string   "comment"
    t.integer  "person_id"
    t.integer  "invited_by_id"
    t.integer  "event_id"
    t.integer  "referrer_datum_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["event_id"], name: "index_attendances_on_event_id", using: :btree
    t.index ["invited_by_id"], name: "index_attendances_on_invited_by_id", using: :btree
    t.index ["person_id"], name: "index_attendances_on_person_id", using: :btree
    t.index ["referrer_datum_id"], name: "index_attendances_on_referrer_datum_id", using: :btree
  end

  create_table "canvasses", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.string   "contact_type"
    t.string   "imput_type"
    t.boolean  "sucess"
    t.string   "status_code"
    t.integer  "canvassing_effort_id"
    t.integer  "canvasser_id"
    t.integer  "target_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["canvasser_id"], name: "index_canvasses_on_canvasser_id", using: :btree
    t.index ["canvassing_effort_id"], name: "index_canvasses_on_canvassing_effort_id", using: :btree
    t.index ["target_id"], name: "index_canvasses_on_target_id", using: :btree
  end

  create_table "canvasses_answers", id: false, force: :cascade do |t|
    t.integer "canvass_id"
    t.integer "answer_id"
    t.index ["answer_id"], name: "index_canvasses_answers_on_answer_id", using: :btree
    t.index ["canvass_id"], name: "index_canvasses_answers_on_canvass_id", using: :btree
  end

  create_table "canvassing_efforts", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "type"
    t.integer  "total_canvasses"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.integer  "script_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["creator_id"], name: "index_canvassing_efforts_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_canvassing_efforts_on_modified_by_id", using: :btree
    t.index ["script_id"], name: "index_canvassing_efforts_on_script_id", using: :btree
  end

  create_table "canvassing_efforts_groups", id: false, force: :cascade do |t|
    t.integer "canvassing_effort_id"
    t.integer "group_id"
    t.index ["canvassing_effort_id"], name: "index_canvassing_efforts_groups_on_canvassing_effort_id", using: :btree
    t.index ["group_id"], name: "index_canvassing_efforts_groups_on_group_id", using: :btree
  end

  create_table "canvassing_efforts_questions", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "canvassing_effort_id"
    t.index ["canvassing_effort_id"], name: "index_canvassing_efforts_questions_on_canvassing_effort_id", using: :btree
    t.index ["question_id"], name: "index_canvassing_efforts_questions_on_question_id", using: :btree
  end

  create_table "donations", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.float    "amount"
    t.float    "credited_amount"
    t.datetime "created_date"
    t.string   "currency"
    t.string   "subscription_instance"
    t.boolean  "voided"
    t.datetime "voided_date"
    t.string   "url"
    t.integer  "referrer_data_id"
    t.integer  "person_id"
    t.integer  "fundraising_page_id"
    t.integer  "attendance_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["attendance_id"], name: "index_donations_on_attendance_id", using: :btree
    t.index ["fundraising_page_id"], name: "index_donations_on_fundraising_page_id", using: :btree
    t.index ["person_id"], name: "index_donations_on_person_id", using: :btree
    t.index ["referrer_data_id"], name: "index_donations_on_referrer_data_id", using: :btree
  end

  create_table "email_addresses", force: :cascade do |t|
    t.boolean  "primary"
    t.string   "address"
    t.string   "address_type"
    t.string   "status"
    t.integer  "person_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["person_id"], name: "index_email_addresses_on_person_id", using: :btree
  end

  create_table "email_shares", force: :cascade do |t|
    t.integer  "share_page_id"
    t.string   "subject"
    t.string   "body"
    t.integer  "total_shares"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["share_page_id"], name: "index_email_shares_on_share_page_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.string   "type"
    t.string   "ticket_levels"
    t.string   "featured_image_url"
    t.integer  "total_accepted"
    t.integer  "total_tickets"
    t.float    "total_amount"
    t.string   "status"
    t.string   "instructions"
    t.datetime "start_date"
    t.datetime "end_date"
    t.date     "all_day_date"
    t.boolean  "all_day"
    t.integer  "capacity"
    t.boolean  "guests_can_invite_others"
    t.string   "transparency"
    t.string   "visibility"
    t.integer  "creator_id"
    t.integer  "organizer_id"
    t.integer  "modified_by_id"
    t.integer  "ticket_levels_id"
    t.integer  "address_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["address_id"], name: "index_events_on_address_id", using: :btree
    t.index ["creator_id"], name: "index_events_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_events_on_modified_by_id", using: :btree
    t.index ["organizer_id"], name: "index_events_on_organizer_id", using: :btree
    t.index ["ticket_levels_id"], name: "index_events_on_ticket_levels_id", using: :btree
  end

  create_table "events_groups", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "group_id"
    t.index ["event_id"], name: "index_events_groups_on_event_id", using: :btree
    t.index ["group_id"], name: "index_events_groups_on_group_id", using: :btree
  end

  create_table "facebook_shares", force: :cascade do |t|
    t.integer  "share_page_id"
    t.string   "title"
    t.string   "description"
    t.string   "image"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["share_page_id"], name: "index_facebook_shares_on_share_page_id", using: :btree
  end

  create_table "forms", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "call_to_action"
    t.string   "browser_url"
    t.string   "featured_image_url"
    t.integer  "total_submissions"
    t.integer  "person_id"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.integer  "submissions_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["creator_id"], name: "index_forms_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_forms_on_modified_by_id", using: :btree
    t.index ["person_id"], name: "index_forms_on_person_id", using: :btree
    t.index ["submissions_id"], name: "index_forms_on_submissions_id", using: :btree
  end

  create_table "forms_groups", id: false, force: :cascade do |t|
    t.integer "form_id"
    t.integer "group_id"
    t.index ["form_id"], name: "index_forms_groups_on_form_id", using: :btree
    t.index ["group_id"], name: "index_forms_groups_on_group_id", using: :btree
  end

  create_table "fundraising_pages", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.string   "featured_image_url"
    t.integer  "total_donations"
    t.float    "total_amount"
    t.string   "currency"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["creator_id"], name: "index_fundraising_pages_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_fundraising_pages_on_modified_by_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.string   "featured_image_url"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_groups_on_modified_by_id", using: :btree
  end

  create_table "groups_petitions", id: false, force: :cascade do |t|
    t.integer "petition_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_groups_petitions_on_group_id", using: :btree
    t.index ["petition_id"], name: "index_groups_petitions_on_petition_id", using: :btree
  end

  create_table "groups_share_pages", id: false, force: :cascade do |t|
    t.integer "share_page_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_groups_share_pages_on_group_id", using: :btree
    t.index ["share_page_id"], name: "index_groups_share_pages_on_share_page_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "person_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id", using: :btree
    t.index ["person_id"], name: "index_memberships_on_person_id", using: :btree
  end

  create_table "outreaches", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.string   "type"
    t.integer  "duration"
    t.string   "subject"
    t.string   "message"
    t.integer  "referrer_data_id"
    t.integer  "advocacy_campaign_id"
    t.integer  "person_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["advocacy_campaign_id"], name: "index_outreaches_on_advocacy_campaign_id", using: :btree
    t.index ["person_id"], name: "index_outreaches_on_person_id", using: :btree
    t.index ["referrer_data_id"], name: "index_outreaches_on_referrer_data_id", using: :btree
  end

  create_table "outreaches_targets", id: false, force: :cascade do |t|
    t.integer "target_id"
    t.integer "outreach_id"
    t.index ["outreach_id"], name: "index_outreaches_targets_on_outreach_id", using: :btree
    t.index ["target_id"], name: "index_outreaches_targets_on_target_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.string   "method"
    t.string   "reference_number"
    t.boolean  "authorization_stored"
    t.integer  "donation_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["donation_id"], name: "index_payments_on_donation_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "identifiers"
    t.string   "array"
    t.string   "family_name"
    t.string   "given_name"
    t.string   "additional_name"
    t.string   "honorific_prefix"
    t.string   "honorific_sufix"
    t.string   "gender"
    t.string   "gender_identity"
    t.string   "party_identification"
    t.string   "source"
    t.string   "ethnicities"
    t.string   "languages_spoken"
    t.date     "birthdate"
    t.string   "employer"
    t.text     "custom_fields"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  end

  create_table "people_groups", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_people_groups_on_group_id", using: :btree
    t.index ["person_id"], name: "index_people_groups_on_person_id", using: :btree
  end

  create_table "petitions", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.string   "featured_image_url"
    t.string   "petition_text"
    t.integer  "total_signatures"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["creator_id"], name: "index_petitions_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_petitions_on_modified_by_id", using: :btree
  end

  create_table "petitions_signatures", id: false, force: :cascade do |t|
    t.integer "signature_id"
    t.integer "petition_id"
    t.index ["petition_id"], name: "index_petitions_signatures_on_petition_id", using: :btree
    t.index ["signature_id"], name: "index_petitions_signatures_on_signature_id", using: :btree
  end

  create_table "petitions_targets", id: false, force: :cascade do |t|
    t.integer "target_id"
    t.integer "petition_id"
    t.index ["petition_id"], name: "index_petitions_targets_on_petition_id", using: :btree
    t.index ["target_id"], name: "index_petitions_targets_on_target_id", using: :btree
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.boolean  "primary"
    t.string   "number"
    t.string   "extension"
    t.string   "description"
    t.string   "number_type"
    t.string   "operator"
    t.string   "country"
    t.boolean  "sms_capable"
    t.boolean  "do_not_call"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["person_id"], name: "index_phone_numbers_on_person_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "provider"
    t.integer  "person_id"
    t.string   "url"
    t.string   "handle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_profiles_on_person_id", using: :btree
  end

  create_table "queries", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.integer  "total_results"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "question_type"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["creator_id"], name: "index_questions_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_questions_on_modified_by_id", using: :btree
  end

  create_table "questions_reponses", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "response_id"
    t.index ["question_id"], name: "index_questions_reponses_on_question_id", using: :btree
    t.index ["response_id"], name: "index_questions_reponses_on_response_id", using: :btree
  end

  create_table "recipients", force: :cascade do |t|
    t.string   "display_name"
    t.string   "legal_name"
    t.float    "amount"
    t.integer  "donation_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["donation_id"], name: "index_recipients_on_donation_id", using: :btree
  end

  create_table "referrer_data", force: :cascade do |t|
    t.string   "source"
    t.string   "referrer"
    t.string   "website"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminders", force: :cascade do |t|
    t.string   "method"
    t.string   "minutes"
    t.integer  "person_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_reminders_on_event_id", using: :btree
    t.index ["person_id"], name: "index_reminders_on_person_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "title"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_responses_on_question_id", using: :btree
  end

  create_table "script_questions", force: :cascade do |t|
    t.integer  "sequence"
    t.integer  "question_id"
    t.integer  "script_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["question_id"], name: "index_script_questions_on_question_id", using: :btree
    t.index ["script_id"], name: "index_script_questions_on_script_id", using: :btree
  end

  create_table "scripts", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.integer  "canvassing_effort_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["canvassing_effort_id"], name: "index_scripts_on_canvassing_effort_id", using: :btree
    t.index ["creator_id"], name: "index_scripts_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_scripts_on_modified_by_id", using: :btree
  end

  create_table "share_pages", force: :cascade do |t|
    t.string   "origin_system"
    t.string   "name"
    t.string   "title"
    t.string   "description"
    t.string   "summary"
    t.string   "browser_url"
    t.string   "share_url"
    t.integer  "total_shares"
    t.integer  "creator_id"
    t.integer  "modified_by_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["creator_id"], name: "index_share_pages_on_creator_id", using: :btree
    t.index ["modified_by_id"], name: "index_share_pages_on_modified_by_id", using: :btree
  end

  create_table "signatures", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.string   "comments"
    t.integer  "referrer_data_id"
    t.integer  "petition_id"
    t.integer  "person_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["person_id"], name: "index_signatures_on_person_id", using: :btree
    t.index ["petition_id"], name: "index_signatures_on_petition_id", using: :btree
    t.index ["referrer_data_id"], name: "index_signatures_on_referrer_data_id", using: :btree
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "origin_system"
    t.datetime "action_date"
    t.integer  "referrer_data_id"
    t.integer  "person_id"
    t.integer  "form_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["form_id"], name: "index_submissions_on_form_id", using: :btree
    t.index ["person_id"], name: "index_submissions_on_person_id", using: :btree
    t.index ["referrer_data_id"], name: "index_submissions_on_referrer_data_id", using: :btree
  end

  create_table "targets", force: :cascade do |t|
    t.string   "title"
    t.string   "organization"
    t.string   "given_name"
    t.string   "family_name"
    t.string   "ocdid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "ticket_levels", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.float    "amount"
    t.string   "currency"
    t.integer  "limit"
    t.integer  "total_tickets"
    t.float    "total_amount"
    t.integer  "event_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["event_id"], name: "index_ticket_levels_on_event_id", using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.float    "amount"
    t.string   "currency"
    t.string   "attended"
    t.integer  "attendance_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["attendance_id"], name: "index_tickets_on_attendance_id", using: :btree
  end

  create_table "twitter_shares", force: :cascade do |t|
    t.integer  "share_page_id"
    t.string   "message"
    t.integer  "total_shares"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["share_page_id"], name: "index_twitter_shares_on_share_page_id", using: :btree
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string   "zipcode"
    t.string   "zipcode_type"
    t.string   "city"
    t.string   "state"
    t.string   "location_type"
    t.float    "lat"
    t.float    "long"
    t.string   "location"
    t.boolean  "decommisioned"
    t.boolean  "tax_returns_filed"
    t.integer  "estimated_population"
    t.integer  "total_wages"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_foreign_key "answers", "canvasses"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "responses", column: "responses_id"
  add_foreign_key "donations", "attendances"
  add_foreign_key "donations", "fundraising_pages"
  add_foreign_key "donations", "people"
  add_foreign_key "donations", "referrer_data"
  add_foreign_key "email_shares", "share_pages"
  add_foreign_key "events", "addresses"
  add_foreign_key "events", "ticket_levels", column: "ticket_levels_id"
  add_foreign_key "facebook_shares", "share_pages"
  add_foreign_key "forms", "people"
  add_foreign_key "forms", "submissions", column: "submissions_id"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "people"
  add_foreign_key "outreaches", "advocacy_campaigns"
  add_foreign_key "outreaches", "people"
  add_foreign_key "outreaches", "referrer_data"
  add_foreign_key "payments", "donations"
  add_foreign_key "recipients", "donations"
  add_foreign_key "reminders", "events"
  add_foreign_key "reminders", "people"
  add_foreign_key "script_questions", "questions"
  add_foreign_key "script_questions", "scripts"
  add_foreign_key "scripts", "canvassing_efforts"
  add_foreign_key "signatures", "people"
  add_foreign_key "signatures", "petitions"
  add_foreign_key "signatures", "referrer_data"
  add_foreign_key "twitter_shares", "share_pages"
end
