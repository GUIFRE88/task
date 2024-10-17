ActiveRecord::Schema.define(version: 2024_10_17_001120) do

  create_table "tasks", charset: "utf8", force: :cascade do |t|
    t.string "url", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
