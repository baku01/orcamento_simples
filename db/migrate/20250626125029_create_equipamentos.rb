# frozen_string_literal: true
# typed: true

class CreateEquipamentos < ActiveRecord::Migration[8.0]
  def change
    create_table :equipamentos do |t|
      t.primary_key :id
      t.string :nome
      t.decimal :valor_hora

      t.timestamps
    end
  end
end
