# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

# == Schema Information
#
# Table name: funcoes
#
#  nome                 :string   not null, max 25 chars
#  valor_base           :decimal  not null
#  valor_base_adicional :decimal  not null
#  tipo                 :integer  not null, enum [moi: 0, mod: 1]
#
# Classe responsável por representar uma função orçamentária.
#
class Funcao < ApplicationRecord
  extend T::Sig

  before_validation :formatar_nome

  has_many :proposta_funcoes, dependent: :destroy
  has_many :propostas, through: :proposta_funcoes

  enum :tipo, { moi: 0, mod: 1 }
  validates :nome, presence: true, length: { maximum: 25 }
  validates :valor_base, presence: true, numericality: { greater_than: 0 }
  validates :valor_base_adicional, presence: true, numericality: { greater_than: 0 }
  validates :tipo, presence: true

  # Calcula a taxa de variação da função usando o serviço CalculadoraOrcamentariaService.
  #
  # @return [BigDecimal] a taxa de variação calculada
  #
  # @example
  #   funcao.pega_taxa_variacao #=> #<BigDecimal:...>
  sig { returns(BigDecimal) }
  def pega_taxa_variacao
    CalculadoraOrcamentariaService.taxa_de_variacao_funcao(
      valor_base: T.must(valor_base),
      valor_base_adicional: T.must(valor_base_adicional),
    )
  end

  private

  # Formata o nome da função para uppercase antes da validação.
  #
  # @return [void]
  sig { returns(String) }
  def formatar_nome
    T.must(self.nome = FormatadorValores.para_uppercase(texto: T.must(nome)))
  end
end
