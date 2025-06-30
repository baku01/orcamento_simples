# typed: strict
# frozen_string_literal: true

require 'rails_helper'
require 'sorbet-runtime'

RSpec.describe(FuncaoService) do
  context 'quando procurar no banco' do
    let(:id_procurado) { Integer(1) }
    it 'retorna a função com o id procurado' do
      funcao = Funcao::BancoDeDados.pega_f

    end
  end
end
