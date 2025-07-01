# typed: true
# frozen_string_literal: true

require "sorbet-runtime"
# typed: strict

# == Proposta
#
# Representa uma proposta orçamentária completa, incluindo funções, equipamentos,
# valores calculados e informações de controle como revisão e identificação única.
#
# === Schema Information
# Table name: propostas
#
#  id                :integer not null, unique
#  revisao           :integer not null
#  quantidade_horas  :decimal not null, > 0
#  despesa_indireta  :decimal not null, > 0
#  margem_lucro_fixa :decimal not null, > 0
#  margem_lucro      :decimal not null, > 0
#  valor_total       :decimal not null, > 0
#  valor_hora        :decimal not null, > 0
#
# === Validações
# * +id+ deve ser único, presente e um número inteiro
# * +revisao+ deve estar presente e ser um número inteiro
# * +quantidade_horas+ deve estar presente e ser maior que zero
# * +despesa_indireta+ deve estar presente e ser maior que zero
# * +margem_lucro_fixa+ deve estar presente e ser maior que zero
# * +margem_lucro+ deve estar presente e ser maior que zero
# * +valor_total+ deve estar presente e ser maior que zero
# * +valor_hora+ deve estar presente e ser maior que zero
#
# === Relacionamentos
# * +has_many+ :proposta_funcoes - associações com funções
# * +has_many+ :funcoes, through: :proposta_funcoes - funções utilizadas na proposta
# * +has_many+ :proposta_equipamentos - associações com equipamentos
# * +has_many+ :equipamentos, through: :proposta_equipamentos - equipamentos utilizados
#
# === Conceitos de Negócio
# * +despesa_indireta+: Custos que não estão diretamente ligados à execução (ex: administração)
# * +margem_lucro_fixa+: Percentual de lucro aplicado sobre os custos
# * +margem_lucro+: Valor absoluto de lucro calculado
# * +valor_hora+: Valor médio por hora da proposta
# * +revisao+: Controle de versões da proposta
#
# === Exemplos de uso
#   # Criar uma nova proposta
#   proposta = Proposta.new(
#     id: 2024001,
#     quantidade_horas: 160.0,
#     despesa_indireta: 5000.00,
#     margem_lucro_fixa: 0.15,
#     margem_lucro: 2250.00,
#     valor_total: 17250.00,
#     valor_hora: 107.81
#   )
#
#   # Buscar valor base de uma função específica
#   valor_base = proposta.pega_valor_base(funcao_id)
#
class Proposta < ApplicationRecord
  extend T::Sig

  # === Relacionamentos
  has_many :proposta_funcoes, dependent: :destroy
  has_many :funcoes, through: :proposta_funcoes

  has_many :proposta_equipamentos, dependent: :destroy
  has_many :equipamentos, through: :proposta_equipamentos

  # === Validações
  validates :id, presence: true, numericality: { only_integer: true }, uniqueness: true
  validates :revisao, presence: true, numericality: { only_integer: true }
  validates :quantidade_horas, presence: true, numericality: { greater_than: 0 }
  validates :despesa_indireta, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro_fixa, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro, presence: true, numericality: { greater_than: 0 }
  validates :valor_total, presence: true, numericality: { greater_than: 0 }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # === Métodos Públicos

  # Recupera o valor base de uma função específica utilizada na proposta.
  #
  # Busca a função pelo ID fornecido e retorna seu valor base, que é utilizado
  # como referência para cálculos orçamentários.
  #
  # @param id_funcao [Integer] ID da função a ser consultada
  #
  # @return [BigDecimal] Valor base da função
  #
  # @raise [ArgumentError] Se a função não for encontrada ou se o valor base for nulo
  #
  # @example Obter valor base de uma função
  #   proposta = Proposta.find(1)
  #   valor_base = proposta.pega_valor_base(5)
  #   # => #<BigDecimal:0x... "80.0">
  #
  # @example Tratamento de erro para função inexistente
  #   proposta.pega_valor_base(999)
  #   # => ArgumentError: Função com id 999 não encontrada.
  #
  sig { params(id_funcao: Integer).returns(BigDecimal) }
  def pega_valor_base(id_funcao)
    funcao = Funcao.find_by(id: id_funcao)
    raise ArgumentError, "Função com id #{id_funcao} não encontrada." if funcao.nil?

    valor_base = funcao.valor_base
    raise ArgumentError, "Valor base da função com id #{id_funcao} é nulo." if valor_base.nil?

    valor_base
  end

  private

  # === Métodos Privados

  # Define automaticamente o número da revisão da proposta.
  #
  # Busca a maior revisão existente no sistema e incrementa em 1 para definir
  # a revisão da nova proposta, garantindo controle sequencial de versões.
  #
  # @return [void]
  #
  # @note Este método deve ser chamado antes de salvar uma nova proposta
  #
  sig { void }
  def definir_revisao
    revisao_max = T.let(Proposta.maximum(:revisao), T.nilable(Integer))
    ultima_revisao = revisao_max || 0
    self.revisao = ultima_revisao + 1
  end
end
