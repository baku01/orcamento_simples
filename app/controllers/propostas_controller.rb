# typed: true
# frozen_string_literal: true

require "sorbet-runtime"

class PropostasController < ApplicationController
  extend T::Sig

  sig { void }
  def initialize
    super
    @proposta = T.let(Proposta.new, Proposta)
    @funcoes = T.let(FuncaoService::BancoDeDados.pega_todas_funcoes, T::Array[Funcao])
    ordenar_funcoes
  end

  private

  sig { void }
  def ordenar_funcoes
    @funcoes = @funcoes.sort_by { |funcao| funcao.nome.to_s.capitalize }
  end
end
