# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_21_193940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer "template_version"
    t.string "friendly_from"
    t.string "subject"
    t.string "ip_pool"
    t.string "sending_domain"
    t.text "rcpt_tags", default: [], array: true
    t.string "type"
    t.string "raw_rcpt_to"
    t.string "msg_from"
    t.string "rcpt_to"
    t.string "report_to"
    t.integer "transmission_id"
    t.string "fbtype"
    t.json "rcpt_meta"
    t.string "message_id"
    t.string "recipient_domain"
    t.string "report_by"
    t.integer "event_id"
    t.string "routing_domain"
    t.float "sending_ip"
    t.string "template_id"
    t.string "delv_method"
    t.datetime "injection_time"
    t.integer "msg_size"
    t.datetime "timestamp"
    t.datetime "formattedDate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
