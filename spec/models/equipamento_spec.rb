# typed: false
# frozen_string_literal: true

require 'rails_helper'
require 'sorbet-runtime'

RSpec.describe Equipamento, type: :model do
  context 'validações' do
    subject(:equipamento) { described_class.new(nome: 'MUNCK', valor_hora: 10_000_000.to_d) }

    context 'quando os atributos são válidos' do
      it 'é válido' do
        expect(equipamento).to be_valid
      end
    end

    context 'quando o nome está ausente' do
      before { equipamento.nome = nil }

      it 'é inválido' do
        expect(equipamento).not_to be_valid
      end
    end

    context 'quando o valor_hora é zero ou negativo' do
      before { equipamento.valor_hora = 0 }

      it 'é inválido' do
        expect(equipamento).not_to be_valid
      end
    end

    context 'quando o nome está em minúsculo' do
      before { equipamento.nome = 'munck' }

      it 'é válido' do
        expect(equipamento).to be_valid
     end
    end
  end
end
