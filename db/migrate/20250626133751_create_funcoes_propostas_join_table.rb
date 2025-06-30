# frozen_string_literal: true
# typed: true

class CreateFuncoesPropostasJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :propostas, :funcaos do |t|
      t.index :proposta_id
      t.index :funcao_id
    end
  end
end
