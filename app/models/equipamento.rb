# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# == Equipamento
#
# Representa um equipamento utilizado em orçamentos de projetos.
# Cada equipamento possui um nome único e um valor por hora de utilização.
#
# === Schema Information
# Table name: equipamentos
#
#  nome        :string     not null, max 50 chars
#  valor_hora  :decimal    not null, > 0
#
# === Validações
# * +nome+ deve estar presente e ter no máximo 50 caracteres
# * +valor_hora+ deve estar presente e ser maior que zero
#
# === Relacionamentos
# * Pode estar associado a múltiplas propostas através de proposta_equipamentos
#
# === Exemplos de uso
#   # Criar um novo equipamento
#   equipamento = Equipamento.new(nome: "Escavadeira", valor_hora: 150.00)
#   equipamento.save
#
#   # Calcular valor de venda
#   valor = equipamento.pega_valor_venda(
#     quantidade_horas: 8.0,
#     despesa_indireta: BigDecimal("100.0"),
#     margem_lucro_fixa: BigDecimal("0.1"),
#     imposto: BigDecimal("0.10")
#   )
#
class Equipamento < ApplicationRecord
  extend T::Sig

  # === Validações
  validates :nome, presence: true, length: { maximum: 50 }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # === Métodos Públicos

  # Calcula o valor de venda do equipamento para uma proposta específica.
  #
  # Utiliza o serviço CalculadoraOrcamentariaService para aplicar despesas indiretas,
  # margem de lucro e impostos sobre o valor base por hora do equipamento.
  #
  # @param quantidade_horas [Float] Número de horas que o equipamento será utilizado
  # @param despesa_indireta [BigDecimal] Valor total das despesas indiretas do projeto
  # @param margem_lucro_fixa [BigDecimal] Percentual de margem de lucro (ex: 0.1 para 10%)
  # @param imposto [BigDecimal] Percentual de imposto aplicado (ex: 0.10 para 10%)
  #
  # @return [BigDecimal] Valor de venda calculado para o equipamento
  #
  # @raise [ArgumentError] Se algum parâmetro for inválido ou negativo
  #
  # @example Calcular valor para 8 horas de uso
  #   equipamento = Equipamento.find(1)
  #   valor = equipamento.pega_valor_venda(
  #     8.0,
  #     BigDecimal("500.0"),
  #     BigDecimal("0.15"),
  #     BigDecimal("0.12")
  #   )
  #   # => #<BigDecimal:0x... "1392.0">
  #
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
