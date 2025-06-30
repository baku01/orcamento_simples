# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Módulo responsável por operações relacionadas ao salário.
#
# SalarioService fornece métodos para calcular variações e aumentos salariais.
#
module SalarioService
  class << self
    extend T::Sig

    # Calcula a taxa de variação percentual entre o valor_base e o valor_aumento.
    #
    # @param valor_base [BigDecimal] O valor original do salário.
    # @param valor_aumento [BigDecimal] O valor do aumento aplicado.
    # @return [BigDecimal] A variação percentual.
    sig { params(valor_base: BigDecimal, valor_aumento: BigDecimal).returns(BigDecimal) }
    def calcular_taxa_variacao(valor_base, valor_aumento)
      valor_aumento / valor_base
    end

    # Calcula a taxa de variação percentual entre o valor_base e o valor_aumento.
    #
    # @param valor_base [BigDecimal] O valor original do salário.
    # @param valor_aumento [BigDecimal] O valor do aumento aplicado.
    # @return [BigDecimal] A variação percentual.
    sig { params(valor_base: BigDecimal, valor_aumento: BigDecimal).returns(BigDecimal) }
    def calcular_taxa_variacao_porcentagem(valor_base, valor_aumento)
      calcular_taxa_variacao(valor_base, valor_aumento) * 100
    end
  end
end
