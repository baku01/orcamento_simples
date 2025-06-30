# typed: true
# frozen_string_literal: true

class PropostaFuncaoJoin < ApplicationRecord
  extend T::Sig

  belongs_to :proposta
  belongs_to :funcao

  validates :valor_hora, presence: true, numericality: { greater_than: 0 }
  validates :horas_previstas, presence: true, numericality: { greater_than: 0 }
end
