# typed: true
# frozen_string_literal: true

# == PropostaFuncaoJoin
#
# Tabela de associação entre Proposta e Funcao, armazenando informações específicas
# da utilização de cada função em uma proposta particular.
#
# Esta classe implementa o padrão "Rich Join Table", onde além da associação
# many-to-many, são armazenados dados específicos da relação como valor por hora
# negociado e horas previstas para a função na proposta.
#
# === Schema Information
# Table name: proposta_funcao_joins (assumed)
#
#  proposta_id     :integer  not null, foreign key
#  funcao_id       :integer  not null, foreign key
#  valor_hora      :decimal  not null, > 0
#  horas_previstas :decimal  not null, > 0
#
# === Validações
# * +valor_hora+ deve estar presente e ser maior que zero
# * +horas_previstas+ deve estar presente e ser maior que zero
#
# === Relacionamentos
# * +belongs_to+ :proposta - proposta à qual esta associação pertence
# * +belongs_to+ :funcao - função utilizada na proposta
#
# === Conceitos de Negócio
# * +valor_hora+: Valor por hora específico para esta função nesta proposta
# * +horas_previstas+: Quantidade de horas estimadas para esta função na proposta
#
# === Exemplos de uso
#   # Associar uma função a uma proposta com valores específicos
#   proposta_funcao = PropostaFuncaoJoin.new(
#     proposta: proposta,
#     funcao: funcao_engenheiro,
#     valor_hora: 95.00,
#     horas_previstas: 40.0
#   )
#   proposta_funcao.save
#
#   # Calcular valor total desta função na proposta
#   valor_total = proposta_funcao.valor_hora * proposta_funcao.horas_previstas
#   # => #<BigDecimal "3800.0">
#
class PropostaFuncaoJoin < ApplicationRecord
  extend T::Sig

  # === Relacionamentos
  belongs_to :proposta
  belongs_to :funcao

  # === Validações
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }
  validates :horas_previstas, presence: true, numericality: { greater_than: 0 }

  # === Métodos Públicos
  # TODO: Adicionar métodos de negócio como calcular_valor_total, calcular_custo_funcao, etc.
end
