# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

class PropostasController < ApplicationController
  extend T::Sig

  sig { void }
  def new
    @proposta = Proposta.new
    @funcoes = Funcao.all
  end
end
