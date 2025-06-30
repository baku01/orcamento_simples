# typed: true
# frozen_string_literal: true

class FuncoesController < ApplicationController
  extend T::Sig

  sig { returns(Funcao) }
  def new
    @funcao = Funcao.new
  end

  sig { returns(T::Array[Funcao]) }
  def list_all
    Funcao.all.to_ary
  end
end
