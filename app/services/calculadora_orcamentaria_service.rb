# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# == CalculadoraOrcamentariaService
#
# Serviço responsável pelos cálculos de criação de propostas orçamentárias.
#
# === Exemplo de uso:
#   CalculadoraOrcamentariaService.taxa_de_variacao_funcao(BigDecimal("100"), BigDecimal("120"))
#   CalculadoraOrcamentariaService.valor_venda_mo(BigDecimal("50"), BigDecimal("100"), BigDecimal("0.2"), 10)
#   CalculadoraOrcamentariaService.valor_venda_eqp(100.0, BigDecimal("0.1"), BigDecimal("0.2"), BigDecimal("0.05"), 8)
#
module CalculadoraOrcamentariaService
  class << self
    extend T::Sig

    # Calcula a taxa de variação relativa entre dois valores.
    #
    # @param valor_base [BigDecimal] Valor inicial (base) para o cálculo.
    # @param valor_base_adicional [BigDecimal] Valor adicional para o cálculo.
    # @return [BigDecimal] Taxa de variação relativa (ex: 0.2 para 20% de aumento).
    #
    # @example
    #   CalculadoraOrcamentariaService.taxa_de_variacao_funcao(BigDecimal("100"), BigDecimal("120"))
    #   #=> 0.2
    sig { params(valor_base: BigDecimal, valor_base_adicional: BigDecimal).returns(BigDecimal) }
    def taxa_de_variacao_funcao(valor_base:, valor_base_adicional:)
      (valor_base_adicional - valor_base)
    end

    # Calcula o valor de venda da mão de obra.
    #
    # @param valor_hora [BigDecimal] Valor da hora de trabalho.
    # @param valor_base [BigDecimal] Valor base inicial.
    # @param taxa_variacao [BigDecimal] Taxa de variação a ser aplicada.
    # @param quantidade_horas [Float] Quantidade de horas trabalhadas.
    # @return [BigDecimal] Valor total de venda da mão de obra.
    #
    # @example
    #   CalculadoraOrcamentariaService.valor_venda_mo(
    #     BigDecimal("50"),
    #     BigDecimal("100"),
    #     BigDecimal("0.2"),
    #     10
    #   )
    #   #=> 600.0
    sig do
      params(
        valor_hora: BigDecimal,
        valor_base: BigDecimal,
        taxa_variacao: BigDecimal,
        quantidade_horas: Float,
      ).returns(BigDecimal)
    end
    def valor_venda_mo(valor_hora:, valor_base:, taxa_variacao:, quantidade_horas:)
      ((valor_hora * taxa_variacao) + valor_base) * quantidade_horas
    end

    # Calcula o valor de venda de equipamentos.
    #
    # @param valor_hora [Float] Valor da hora do equipamento.
    # @param despesa_indireta [BigDecimal] Percentual de despesa indireta.
    # @param margem_lucro_fixa [BigDecimal] Percentual de margem de lucro.
    # @param imposto [BigDecimal] Percentual de impostos.
    # @param quantidade_horas [Float] Quantidade de horas de uso do equipamento.
    # @return [BigDecimal] Valor de venda do equipamento.
    #
    # @example
    #   CalculadoraOrcamentariaService.valor_venda_eqp(
    #     100.0,
    #     BigDecimal("0.1"),
    #     BigDecimal("0.2"),
    #     BigDecimal("0.05"),
    #     8
    #   )
    #   #=> 144.73684210526315
    sig do
      params(
        valor_hora: Float,
        despesa_indireta: BigDecimal,
        margem_lucro_fixa: BigDecimal,
        imposto: BigDecimal,
        quantidade_horas: Float,
      ).returns(BigDecimal)
    end
    def valor_venda_eqp(
      valor_hora:,
      despesa_indireta:,
      margem_lucro_fixa:,
      imposto:,
      quantidade_horas:
    )
      (valor_hora * (despesa_indireta / (1 - (margem_lucro_fixa + imposto)))) * quantidade_horas
    end

    # Calcula o valor total dos custos variáveis de um serviço, considerando a margem de lucro.
    #
    # @param valor_custo [BigDecimal] Custo base do serviço.
    # @param margem_lucro [Float] Percentual da margem de lucro a ser aplicada (ex: 0.2 para 20%).
    # @return [BigDecimal] Soma do custo base com a margem de lucro aplicada.
    #
    # @example
    #   CalculadoraOrcamentariaService.custos_variaveis(100.0, 0.2)
    #   #=> 120.0
    sig { params(valor_custo: BigDecimal, margem_lucro: Float).returns(BigDecimal) }
    def custos_variaveis(valor_custo:, margem_lucro:)
      valor_custo + (valor_custo * margem_lucro)
    end
  end
end
