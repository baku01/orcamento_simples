# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
# typed: strict

# == Schema Information
#
# Table name: propostas
#
#  id                :integer not null, unique
#  revisao           :integer not null
#  quantidade_horas  :decimal not null
#  despesa_indireta  :decimal not null
#  margem_lucro_fixa :decimal not null
#  margem_lucro      :decimal not null
#  valor_total       :decimal not null
#  valor_hora        :decimal not null
#
class Proposta < ApplicationRecord
  extend T::Sig

  has_many :proposta_funcoes, dependent: :destroy
  has_many :funcoes, through: :proposta_funcoes
  has_many :proposta_equipamentos, dependent: :destroy
  has_many :equipamentos, through: :proposta_equipamentos

  validates :id, presence: true, numericality: { only_integer: true }, uniqueness: true
  validates :revisao, presence: true, numericality: { only_integer: true }
  validates :quantidade_horas, presence: true, numericality: { greater_than: 0 }
  validates :despesa_indireta, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro_fixa, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro, presence: true, numericality: { greater_than: 0 }
  validates :valor_total, presence: true, numericality: { greater_than: 0 }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # Pega valor base da funcao
  sig { params(id_funcao: Integer).returns(BigDecimal) }
  def pega_valor_base(id_funcao)
    funcao = Funcao.find_by(id: id_funcao)
    raise ArgumentError, "Função com id #{id_funcao} não encontrada." if funcao.nil?

    valor_base = funcao.valor_base
    raise ArgumentError, "Valor base da função com id #{id_funcao} é nulo." if valor_base.nil?

    valor_base
  end
end
