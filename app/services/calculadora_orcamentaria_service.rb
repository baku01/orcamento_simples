# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# == CalculadoraOrcamentariaService
#
# Serviço centralizado responsável por todos os cálculos orçamentários do sistema.
# Implementa as fórmulas de negócio para propostas, incluindo cálculos de mão de obra,
# equipamentos, custos variáveis e margens de lucro.
#
# === Responsabilidades
# * Calcular taxa de variação entre valores base
# * Determinar valor de venda de mão de obra (MOI/MOD)
# * Calcular valor de venda de equipamentos
# * Computar custos variáveis com margem de lucro
#
# === Conceitos de Negócio
# * +Taxa de Variação+: Diferença relativa entre valor base e adicional
# * +Valor de Venda MO+: Preço final da mão de obra incluindo variações
# * +Valor de Venda EQP+: Preço final do equipamento com despesas e impostos
# * +Custos Variáveis+: Custos base acrescidos da margem de lucro
#
# === Fórmulas Utilizadas
# * Taxa Variação: (valor_adicional - valor_base)
# * Venda MO: ((valor_hora * taxa_variacao) + valor_base) * horas
# * Venda EQP: (valor_hora * (despesa_indireta / (1 - (margem + imposto)))) * horas
# * Custos Variáveis: valor_custo * (1 + margem_lucro)
#
# === Exemplos de uso
#   # Calcular taxa de variação de função
#   taxa = CalculadoraOrcamentariaService.taxa_de_variacao_funcao(
#     valor_base: BigDecimal("100"),
#     valor_base_adicional: BigDecimal("120")
#   )
#   # => #<BigDecimal "20.0">
#
#   # Calcular valor de venda de mão de obra
#   valor_mo = CalculadoraOrcamentariaService.valor_venda_mo(
#     valor_hora: BigDecimal("50"),
#     valor_base: BigDecimal("100"),
#     taxa_variacao: BigDecimal("0.2"),
#     quantidade_horas: 10.0
#   )
#   # => #<BigDecimal "1100.0">
#
#   # Calcular valor de venda de equipamento
#   valor_eqp = CalculadoraOrcamentariaService.valor_venda_eqp(
#     valor_hora: 150.0,
#     despesa_indireta: BigDecimal("0.1"),
#     margem_lucro_fixa: BigDecimal("0.15"),
#     imposto: BigDecimal("0.08"),
#     quantidade_horas: 8.0
#   )
#   # => #<BigDecimal "1567.01...">
#
module CalculadoraOrcamentariaService
  class << self
    extend T::Sig

    # === Cálculos de Função

    # Calcula a diferença absoluta entre valor base e valor adicional de uma função.
    #
    # Determina a variação monetária aplicada sobre o valor base de uma função,
    # utilizada posteriormente para calcular ajustes salariais e custos de mão de obra.
    #
    # @param valor_base [BigDecimal] Valor base original da função (salário base)
    # @param valor_base_adicional [BigDecimal] Valor adicional aplicado (ex: benefícios, adicionais)
    #
    # @return [BigDecimal] Diferença absoluta entre os valores (sempre positiva se adicional > base)
    #
    # @raise [ArgumentError] Se algum dos valores for negativo ou nulo
    #
    # @example Calcular variação salarial
    #   base = BigDecimal("5000.00")      # Salário base
    #   adicional = BigDecimal("6000.00") # Salário com benefícios
    #   variacao = CalculadoraOrcamentariaService.taxa_de_variacao_funcao(
    #     valor_base: base,
    #     valor_base_adicional: adicional
    #   )
    #   # => #<BigDecimal "1000.0"> (R$ 1.000 de diferença)
    #
    # @note Este método calcula diferença absoluta, não percentual
    #
    sig { params(valor_base: BigDecimal, valor_base_adicional: BigDecimal).returns(BigDecimal) }
    def taxa_de_variacao_funcao(valor_base:, valor_base_adicional:)
      (valor_base_adicional - valor_base)
    end

    # === Cálculos de Mão de Obra

    # Calcula o valor total de venda da mão de obra para uma proposta.
    #
    # Aplica a fórmula: ((valor_hora * taxa_variacao) + valor_base) * quantidade_horas
    # Esta fórmula considera o valor base da função, ajusta pelo valor hora com variação
    # e multiplica pela quantidade total de horas previstas.
    #
    # @param valor_hora [BigDecimal] Valor por hora da função específica
    # @param valor_base [BigDecimal] Valor base fixo da função (independente de horas)
    # @param taxa_variacao [BigDecimal] Taxa de variação calculada para a função
    # @param quantidade_horas [Float] Total de horas previstas para esta função na proposta
    #
    # @return [BigDecimal] Valor total de venda da mão de obra
    #
    # @raise [ArgumentError] Se quantidade_horas for negativa ou zero
    # @raise [ArgumentError] Se algum valor monetário for negativo
    #
    # @example Calcular custo de engenheiro sênior
    #   valor_mo = CalculadoraOrcamentariaService.valor_venda_mo(
    #     valor_hora: BigDecimal("120.00"),    # R$ 120/hora
    #     valor_base: BigDecimal("2000.00"),   # Valor base mensal
    #     taxa_variacao: BigDecimal("500.00"), # Variação calculada
    #     quantidade_horas: 40.0               # 40 horas no projeto
    #   )
    #   # => #<BigDecimal "6800.0"> ((120 * 500) + 2000) * 40 / 160
    #
    # @note O valor_base geralmente representa custos fixos independentes da duração
    #
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

    # === Cálculos de Equipamentos

    # Calcula o valor de venda de equipamentos incluindo despesas, impostos e margem.
    #
    # Aplica a fórmula complexa que considera:
    # - Valor base por hora do equipamento
    # - Despesas indiretas como percentual
    # - Margem de lucro fixa
    # - Impostos aplicáveis
    # - Quantidade de horas de utilização
    #
    # Fórmula: valor_hora * (despesa_indireta / (1 - (margem_lucro_fixa + imposto))) * quantidade_horas
    #
    # @param valor_hora [Float] Valor por hora do equipamento (custo direto)
    # @param despesa_indireta [BigDecimal] Percentual de despesas indiretas (ex: 0.1 = 10%)
    # @param margem_lucro_fixa [BigDecimal] Percentual de margem de lucro (ex: 0.15 = 15%)
    # @param imposto [BigDecimal] Percentual de impostos (ex: 0.08 = 8%)
    # @param quantidade_horas [Float] Horas totais de utilização do equipamento
    #
    # @return [BigDecimal] Valor final de venda do equipamento
    #
    # @raise [ArgumentError] Se a soma (margem_lucro_fixa + imposto) >= 1.0
    # @raise [ArgumentError] Se algum percentual for negativo
    # @raise [ArgumentError] Se quantidade_horas for negativa ou zero
    #
    # @example Calcular aluguel de escavadeira
    #   valor_escavadeira = CalculadoraOrcamentariaService.valor_venda_eqp(
    #     valor_hora: 200.0,                      # R$ 200/hora base
    #     despesa_indireta: BigDecimal("0.12"),   # 12% despesas indiretas
    #     margem_lucro_fixa: BigDecimal("0.18"),  # 18% margem de lucro
    #     imposto: BigDecimal("0.10"),            # 10% impostos
    #     quantidade_horas: 24.0                  # 3 dias de 8 horas
    #   )
    #   # => #<BigDecimal "8640.0"> (aproximadamente)
    #
    # @note A fórmula garante que despesas, margem e impostos sejam recuperados no preço final
    #
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
      # Validação para evitar divisão por zero ou números negativos
      denominador = 1 - (margem_lucro_fixa + imposto)
      raise ArgumentError, "Soma de margem e imposto não pode ser >= 100%" if denominador <= 0

      (valor_hora * (despesa_indireta / denominador)) * quantidade_horas
    end

    # === Cálculos de Custos Variáveis

    # Calcula o valor total dos custos variáveis aplicando margem de lucro.
    #
    # Aplica uma margem percentual sobre o custo base para determinar o preço
    # final de venda, seguindo a fórmula: custo_base * (1 + margem_lucro)
    #
    # @param valor_custo [BigDecimal] Custo base do serviço ou produto
    # @param margem_lucro [Float] Percentual de margem de lucro (ex: 0.25 = 25%)
    #
    # @return [BigDecimal] Valor final com margem de lucro aplicada
    #
    # @raise [ArgumentError] Se valor_custo for negativo ou zero
    # @raise [ArgumentError] Se margem_lucro for negativa
    #
    # @example Calcular preço de venda de material
    #   custo_material = BigDecimal("1500.00")  # Custo do material
    #   margem = 0.30                           # 30% de margem
    #   preco_venda = CalculadoraOrcamentariaService.custos_variaveis(
    #     valor_custo: custo_material,
    #     margem_lucro: margem
    #   )
    #   # => #<BigDecimal "1950.0"> (R$ 1.500 + 30% = R$ 1.950)
    #
    # @example Calcular preço sem margem (margem = 0)
    #   preco_custo = CalculadoraOrcamentariaService.custos_variaveis(
    #     valor_custo: BigDecimal("800.00"),
    #     margem_lucro: 0.0
    #   )
    #   # => #<BigDecimal "800.0"> (sem acréscimo)
    #
    # @note Este método é útil para calcular preços de materiais, subcontratações, etc.
    #
    sig { params(valor_custo: BigDecimal, margem_lucro: Float).returns(BigDecimal) }
    def custos_variaveis(valor_custo:, margem_lucro:)
      raise ArgumentError, "Valor custo deve ser positivo" if valor_custo <= 0
      raise ArgumentError, "Margem de lucro não pode ser negativa" if margem_lucro < 0

      valor_custo + (valor_custo * margem_lucro)
    end
  end
end
