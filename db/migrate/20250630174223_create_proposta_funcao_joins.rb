class CreatePropostaFuncaoJoins < ActiveRecord::Migration[8.0]
  def change
    create_table :proposta_funcao do |t|
      t.references :proposta, null: false, foreign_key: true
      t.references :funcao, null: false, foreign_key: true
      t.decimal :valor_hora, null: false
      t.decimal :horas_previstas, null: false

      t.timestamps
    end
  end
end
