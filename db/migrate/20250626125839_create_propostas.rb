# frozen_string_literal: true
# typed: true

class CreatePropostas < ActiveRecord::Migration[8.0]
  def change
    create_table :propostas do |t|
      t.primary_key :id
      t.integer :revisao
      t.decimal :quantidade_horas
      t.decimal :despesa_indireta
      t.decimal :margem_lucro_fixa
      t.decimal :margem_lucro
      t.decimal :valor_total
      t.decimal :valor_hora

      t.timestamps
    end
  end
end
