# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131215165950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

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

  create_table "applications", force: true do |t|
    t.integer  "expert_id"
    t.integer  "mission_id"
    t.text     "motivation"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
    t.float    "entreprise_price"
  end

  add_index "applications", ["expert_id"], name: "index_applications_on_expert_id", using: :btree
  add_index "applications", ["mission_id"], name: "index_applications_on_mission_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competences", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cursus", force: true do |t|
    t.string   "diplome"
    t.string   "university"
    t.integer  "years"
    t.integer  "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cursus", ["expert_id"], name: "index_cursus_on_expert_id", using: :btree

  create_table "entreprises", force: true do |t|
    t.string   "name"
    t.string   "tel"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entreprises", ["user_id"], name: "index_entreprises_on_user_id", using: :btree

  create_table "experiences", force: true do |t|
    t.string   "entreprise"
    t.string   "poste"
    t.text     "description"
    t.integer  "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "experiences", ["expert_id"], name: "index_experiences_on_expert_id", using: :btree

  create_table "expert_competences", force: true do |t|
    t.integer  "competence_id"
    t.integer  "expert_id"
    t.integer  "exp_years"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expert_competences", ["competence_id"], name: "index_expert_competences_on_competence_id", using: :btree
  add_index "expert_competences", ["expert_id"], name: "index_expert_competences_on_expert_id", using: :btree

  create_table "expert_secteurs", force: true do |t|
    t.integer  "expert_id"
    t.integer  "secteur_id"
    t.integer  "exp_years"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expert_secteurs", ["expert_id"], name: "index_expert_secteurs_on_expert_id", using: :btree
  add_index "expert_secteurs", ["secteur_id"], name: "index_expert_secteurs_on_secteur_id", using: :btree

  create_table "experts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "tel"
    t.datetime "birthdate"
    t.string   "profile_title"
    t.text     "services"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_id"
  end

  add_index "experts", ["created_at"], name: "index_experts_on_created_at", using: :btree
  add_index "experts", ["profile_title"], name: "index_experts_on_profile_title", using: :btree
  add_index "experts", ["services"], name: "index_experts_on_services", using: :btree
  add_index "experts", ["user_id"], name: "index_experts_on_user_id", using: :btree

  create_table "invitations", force: true do |t|
    t.integer  "expert_id"
    t.integer  "mission_id"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["expert_id"], name: "index_invitations_on_expert_id", using: :btree
  add_index "invitations", ["mission_id"], name: "index_invitations_on_mission_id", using: :btree

  create_table "missions", force: true do |t|
    t.string   "name"
    t.integer  "entreprise_id"
    t.integer  "budget_min"
    t.integer  "budget_max"
    t.integer  "duration_min"
    t.integer  "duration_max"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "town"
    t.string   "postal_code"
    t.text     "description"
    t.integer  "secteur_id"
    t.integer  "competence_id"
    t.integer  "validated"
    t.datetime "validated_at"
    t.integer  "state"
    t.integer  "expert_id"
  end

  add_index "missions", ["budget_max"], name: "index_missions_on_budget_max", using: :btree
  add_index "missions", ["budget_min"], name: "index_missions_on_budget_min", using: :btree
  add_index "missions", ["category_id"], name: "index_missions_on_category_id", using: :btree
  add_index "missions", ["competence_id"], name: "index_missions_on_competence_id", using: :btree
  add_index "missions", ["created_at"], name: "index_missions_on_created_at", using: :btree
  add_index "missions", ["duration_max"], name: "index_missions_on_duration_max", using: :btree
  add_index "missions", ["duration_min"], name: "index_missions_on_duration_min", using: :btree
  add_index "missions", ["entreprise_id"], name: "index_missions_on_entreprise_id", using: :btree
  add_index "missions", ["expert_id"], name: "index_missions_on_expert_id", using: :btree
  add_index "missions", ["secteur_id"], name: "index_missions_on_secteur_id", using: :btree
  add_index "missions", ["state"], name: "index_missions_on_state", using: :btree
  add_index "missions", ["validated"], name: "index_missions_on_validated", using: :btree
  add_index "missions", ["validated_at"], name: "index_missions_on_validated_at", using: :btree

  create_table "notes", force: true do |t|
    t.text     "description"
    t.float    "ponctualite"
    t.float    "qualite"
    t.float    "disponibilite"
    t.float    "courtoisie"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expert_id"
    t.integer  "mission_id"
  end

  add_index "notes", ["expert_id"], name: "index_notes_on_expert_id", using: :btree
  add_index "notes", ["mission_id"], name: "index_notes_on_mission_id", using: :btree

  create_table "responsabilities", force: true do |t|
    t.string   "organisme"
    t.string   "poste"
    t.text     "description"
    t.integer  "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responsabilities", ["expert_id"], name: "index_responsabilities_on_expert_id", using: :btree

  create_table "secteurs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",               default: false, null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
