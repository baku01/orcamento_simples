# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# == Schema Information
#
# Table name: equipamentos
#
#  nome        :string     not null
#  valor_hora  :decimal    not null
#
# Model que representa um equipamento orçamentário.
#
class Equipamento < ApplicationRecord
  extend T::Sig
  validates :nome, presence: true, length: { maximum: 50 }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # Calcula o valor de venda do equipamento usando o serviço CalculadoraOrcamentariaService.
  #
  # @param quantidade_horas [Float] Quantidade de horas de uso do equipamento
  # @param despesa_indireta [BigDecimal] Valor das despesas indiretas
  # @param margem_lucro_fixa [BigDecimal] Margem de lucro fixa
  # @param imposto [BigDecimal] Valor do imposto
  # @return [BigDecimal] Valor de venda calculado
  #
  # @example
  #   equipamento.pega_valor_venda(10,0, BigDecimal("100.0"), BigDecimal("0.1), BigDecimal("0.10"))
  sig do
    params(
      quantidade_horas: Float,
      despesa_indireta: BigDecimal,
      margem_lucro_fixa: BigDecimal,
      imposto: BigDecimal,
    ).returns(BigDecimal)
  end
  def pega_valor_venda(quantidade_horas, despesa_indireta, margem_lucro_fixa, imposto)
    CalculadoraOrcamentariaService.valor_venda_eqp(
      valor_hora: self[:valor_hora],
      despesa_indireta: despesa_indireta,
      margem_lucro_fixa: margem_lucro_fixa,
      imposto: imposto,
      quantidade_horas: quantidade_horas,
    )
  end
end
