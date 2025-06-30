# frozen_string_literal: true
# typed: true

class CreateFuncaos < ActiveRecord::Migration[8.0]
  def change
    create_table :funcaos do |t|
      t.primary_key :id
      t.string :nome, limit: 25
      t.decimal :valor_base
      t.decimal :valor_base_adicional
      t.integer :tipo

      t.timestamps
    end
  end
end
