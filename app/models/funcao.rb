# typed: true
# frozen_string_literal: true

require "sorbet-runtime"

# == Funcao
#
# Representa uma função orçamentária que pode ser do tipo MOI (Mão de Obra Indireta)
# ou MOD (Mão de Obra Direta). Cada função possui valores bases que são utilizados
# para calcular custos em propostas.
#
# === Schema Information
# Table name: funcoes
#
#  nome                 :string   not null, max 25 chars
#  valor_base           :decimal  not null, > 0
#  valor_base_adicional :decimal  not null, > 0
#  tipo                 :integer  not null, enum [moi: 0, mod: 1]
#
# === Validações
# * +nome+ deve estar presente, ter no máximo 25 caracteres e é automaticamente convertido para maiúsculo
# * +valor_base+ deve estar presente e ser maior que zero
# * +valor_base_adicional+ deve estar presente e ser maior que zero
# * +tipo+ deve ser 'moi' (Mão de Obra Indireta) ou 'mod' (Mão de Obra Direta)
#
# === Relacionamentos
# * +has_many+ :proposta_funcoes - associações com propostas
# * +has_many+ :propostas, through: :proposta_funcoes - propostas que utilizam esta função
#
# === Enums
# * +tipo+: { moi: 0, mod: 1 }
#   - moi: Mão de Obra Indireta
#   - mod: Mão de Obra Direta
#
# === Callbacks
# * +before_validation+ :formatar_nome - converte o nome para maiúsculo
#
# === Exemplos de uso
#   # Criar uma nova função MOD
#   funcao = Funcao.new(
#     nome: "engenheiro senior",
#     valor_base: 80.00,
#     valor_base_adicional: 20.00,
#     tipo: :mod
#   )
#   funcao.save
#   puts funcao.nome # => "ENGENHEIRO SENIOR"
#
#   # Calcular taxa de variação
#   taxa = funcao.pega_taxa_variacao
#   # => #<BigDecimal:0x... "0.25">
#
class Funcao < ApplicationRecord
  extend T::Sig

  # === Callbacks
  before_validation :formatar_nome

  # === Relacionamentos
  has_many :proposta_funcoes, dependent: :destroy
  has_many :propostas, through: :proposta_funcoes

  # === Enums
  enum :tipo, { moi: 0, mod: 1 }

  # === Validações
  validates :nome, presence: true, length: { maximum: 25 }
  validates :valor_base, presence: true, numericality: { greater_than: 0 }
  validates :valor_base_adicional, presence: true, numericality: { greater_than: 0 }
  validates :tipo, presence: true

  # === Métodos Públicos

  # Calcula a taxa de variação da função baseada nos valores base.
  #
  # Utiliza o serviço CalculadoraOrcamentariaService para determinar a relação
  # proporcional entre o valor base e o valor base adicional da função.
  #
  # @return [BigDecimal] Taxa de variação calculada como decimal (ex: 0.25 para 25%)
  #
  # @raise [StandardError] Se os valores base forem nulos ou inválidos
  #
  # @example Calcular taxa para uma função
  #   funcao = Funcao.find_by(nome: "ENGENHEIRO SENIOR")
  #   taxa = funcao.pega_taxa_variacao
  #   # => #<BigDecimal:0x... "0.25"> (representa 25%)
  #
  sig { returns(BigDecimal) }
  def pega_taxa_variacao
    CalculadoraOrcamentariaService.taxa_de_variacao_funcao(
      valor_base: T.must(valor_base),
      valor_base_adicional: T.must(valor_base_adicional),
    )
  end

  private

  # === Métodos Privados

  # Formata o nome da função para uppercase antes da validação.
  #
  # Garante que todos os nomes de funções sejam armazenados de forma consistente
  # em letras maiúsculas, utilizando o serviço FormatadorValores.
  #
  # @return [String] Nome formatado em maiúsculo
  #
  sig { returns(String) }
  def formatar_nome
    T.must(self.nome = FormatadorValores.para_uppercase(texto: T.must(nome)))
  end
end
