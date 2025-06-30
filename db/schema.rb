# typed: false
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

ActiveRecord::Schema[8.0].define(version: 2025_06_26_133751) do
  create_table "equipamentos", force: :cascade do |t|
    t.string "nome"
    t.decimal "valor_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipamentos_propostas", force: :cascade do |t|
    t.integer "proposta_id", null: false
    t.integer "equipamento_id", null: false
    t.index ["equipamento_id"], name: "index_equipamentos_propostas_on_equipamento_id"
    t.index ["proposta_id"], name: "index_equipamentos_propostas_on_proposta_id"
  end

  create_table "funcaos", force: :cascade do |t|
    t.string "nome", limit: 25
    t.decimal "valor_base"
    t.decimal "valor_base_adicional"
    t.integer "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funcaos_propostas", id: false, force: :cascade do |t|
    t.integer "proposta_id", null: false
    t.integer "funcao_id", null: false
    t.index ["funcao_id"], name: "index_funcaos_propostas_on_funcao_id"
    t.index ["proposta_id"], name: "index_funcaos_propostas_on_proposta_id"
  end

  create_table "propostas", force: :cascade do |t|
    t.integer "revisao"
    t.decimal "quantidade_horas"
    t.decimal "despesa_indireta"
    t.decimal "margem_lucro_fixa"
    t.decimal "margem_lucro"
    t.decimal "valor_total"
    t.decimal "valor_hora"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
