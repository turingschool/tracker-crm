# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_19_210343) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_feedbacks", force: :cascade do |t|
    t.bigint "interview_question_id", null: false
    t.text "answer"
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interview_question_id"], name: "index_answer_feedbacks_on_interview_question_id"
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "website"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_companies_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email"
    t.string "phone_number"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_contacts_on_company_id"
    t.index ["user_id", "first_name", "last_name"], name: "index_contacts_on_user_id_and_full_name"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "interview_questions", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "job_application_id", null: false
    t.index ["job_application_id"], name: "index_interview_questions_on_job_application_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.string "position_title"
    t.date "date_applied"
    t.integer "status"
    t.text "notes"
    t.text "job_description"
    t.string "application_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.index ["company_id"], name: "index_job_applications_on_company_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "answer_feedbacks", "interview_questions"
  add_foreign_key "companies", "users"
  add_foreign_key "contacts", "companies"
  add_foreign_key "contacts", "users"
  add_foreign_key "interview_questions", "job_applications"
  add_foreign_key "job_applications", "companies"
  add_foreign_key "job_applications", "contacts"
  add_foreign_key "job_applications", "users"
end
