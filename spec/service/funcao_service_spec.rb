# typed: false
# frozen_string_literal: true

require "rails_helper"
require "sorbet-runtime"

ID_PARA_TESTES = 1

RSpec.describe(FuncaoService) do
  context "quando procurar no banco" do
    describe "função" do
      it "deve retornar uma função" do
        funcoes = FuncaoService::BancoDeDados.pega_funcao_por_id(id: ID_PARA_TESTES)

        expect(funcoes).to(be_a(Funcao))
      end

      # Validar amanhã
      it "deve retornar um array de funções" do
        funcoes = FuncaoService::BancoDeDados.pega_todas_funcoes

        expect(funcoes).to(be_an(Array))
      end
    end
  end
end
