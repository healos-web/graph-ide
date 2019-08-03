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

ActiveRecord::Schema.define(version: 2019_04_19_080715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arcs", force: :cascade do |t|
    t.string "arc_type", default: "common"
    t.string "color", default: "#000000"
    t.bigint "graph_id"
    t.bigint "start_node_id"
    t.bigint "finish_node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finish_node_id"], name: "index_arcs_on_finish_node_id"
    t.index ["graph_id"], name: "index_arcs_on_graph_id"
    t.index ["start_node_id"], name: "index_arcs_on_start_node_id"
  end

  create_table "graphs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string "color", default: "#000000"
    t.string "name"
    t.bigint "graph_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "x"
    t.decimal "y"
    t.integer "leaving_arcs_count"
    t.integer "incoming_arcs_count"
    t.index ["graph_id"], name: "index_nodes_on_graph_id"
  end

end
