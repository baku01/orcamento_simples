# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# == SalarioService
#
# Serviço especializado em cálculos relacionados a salários e variações salariais.
# Fornece métodos utilitários para determinar aumentos, reduções e variações
# percentuais em valores monetários relacionados à folha de pagamento.
#
# === Responsabilidades
# * Calcular taxas de variação entre valores salariais
# * Converter variações para percentuais
# * Fornecer base para análises de reajustes salariais
# * Validar consistência de cálculos monetários
#
# === Conceitos de Negócio
# * +Taxa de Variação+: Relação proporcional entre valor original e aumento
# * +Variação Percentual+: Taxa expressa em percentual (multiplicada por 100)
# * +Valor Base+: Salário ou valor original antes do reajuste
# * +Valor Aumento+: Montante adicional aplicado ao valor base
#
# === Fórmulas Utilizadas
# * Taxa Variação = valor_aumento / valor_base
# * Percentual = taxa_variacao * 100
#
# === Casos de Uso
# * Calcular percentual de aumento salarial
# * Analisar impacto de reajustes na folha
# * Determinar variações para cálculos orçamentários
# * Comparar diferentes cenários de remuneração
#
# === Exemplos de uso
#   # Calcular aumento de 15% sobre salário base
#   base = BigDecimal("5000.00")
#   aumento = BigDecimal("750.00")
#   taxa = SalarioService.calcular_taxa_variacao(base, aumento)
#   # => #<BigDecimal "0.15">
#
#   # Converter para percentual
#   percentual = SalarioService.calcular_taxa_variacao_porcentagem(base, aumento)
#   # => #<BigDecimal "15.0">
#
module SalarioService
  class << self
    extend T::Sig

    # === Cálculos de Variação

    # Calcula a taxa de variação proporcional entre valor base e aumento.
    #
    # Determina qual fração do valor base representa o aumento aplicado,
    # resultando em um valor decimal que pode ser interpretado como percentual
    # quando multiplicado por 100.
    #
    # @param valor_base [BigDecimal] Valor original (salário base, valor inicial)
    # @param valor_aumento [BigDecimal] Valor do aumento aplicado (não o valor final)
    #
    # @return [BigDecimal] Taxa de variação como decimal (ex: 0.15 = 15% de aumento)
    #
    # @raise [ArgumentError] Se valor_base for zero ou negativo
    # @raise [ArgumentError] Se valor_aumento for negativo
    #
    # @example Calcular aumento salarial
    #   salario_base = BigDecimal("4000.00")
    #   aumento_aplicado = BigDecimal("600.00")  # R$ 600 de aumento
    #   taxa = SalarioService.calcular_taxa_variacao(salario_base, aumento_aplicado)
    #   # => #<BigDecimal "0.15"> (15% de aumento)
    #
    # @example Calcular redução salarial
    #   salario_atual = BigDecimal("5000.00")
    #   reducao = BigDecimal("-500.00")  # Redução de R$ 500
    #   taxa = SalarioService.calcular_taxa_variacao(salario_atual, reducao)
    #   # => #<BigDecimal "-0.1"> (-10% de redução)
    #
    # @example Sem alteração
    #   base = BigDecimal("3000.00")
    #   sem_aumento = BigDecimal("0.00")
    #   taxa = SalarioService.calcular_taxa_variacao(base, sem_aumento)
    #   # => #<BigDecimal "0.0"> (0% de variação)
    #
    # @note O resultado é uma proporção, não um percentual direto
    #
    sig { params(valor_base: BigDecimal, valor_aumento: BigDecimal).returns(BigDecimal) }
    def calcular_taxa_variacao(valor_base, valor_aumento)
      raise ArgumentError, "Valor base deve ser positivo" if valor_base <= 0

      valor_aumento / valor_base
    end

    # Calcula a taxa de variação expressa como percentual.
    #
    # Converte o resultado do cálculo de taxa de variação para formato
    # percentual, multiplicando por 100 para facilitar interpretação
    # e apresentação em interfaces de usuário.
    #
    # @param valor_base [BigDecimal] Valor original (salário base, valor inicial)
    # @param valor_aumento [BigDecimal] Valor do aumento aplicado
    #
    # @return [BigDecimal] Taxa de variação em percentual (ex: 15.0 = 15%)
    #
    # @raise [ArgumentError] Se valor_base for zero ou negativo (herdado do método base)
    #
    # @example Mostrar percentual de aumento para usuário
    #   base = BigDecimal("2500.00")
    #   aumento = BigDecimal("375.00")  # R$ 375 de aumento
    #   percentual = SalarioService.calcular_taxa_variacao_porcentagem(base, aumento)
    #   # => #<BigDecimal "15.0">
    #   puts "Aumento de #{percentual}%"  # "Aumento de 15.0%"
    #
    # @example Comparar múltiplos cenários
    #   cenarios = [
    #     { base: BigDecimal("3000"), aumento: BigDecimal("300") },   # 10%
    #     { base: BigDecimal("3000"), aumento: BigDecimal("450") },   # 15%
    #     { base: BigDecimal("3000"), aumento: BigDecimal("600") }    # 20%
    #   ]
    #
    #   cenarios.each_with_index do |cenario, i|
    #     percentual = SalarioService.calcular_taxa_variacao_porcentagem(
    #       cenario[:base],
    #       cenario[:aumento]
    #     )
    #     puts "Cenário #{i+1}: #{percentual}% de aumento"
    #   end
    #
    # @note Este método é um wrapper conveniente para apresentação de dados
    #
    sig { params(valor_base: BigDecimal, valor_aumento: BigDecimal).returns(BigDecimal) }
    def calcular_taxa_variacao_porcentagem(valor_base, valor_aumento)
      calcular_taxa_variacao(valor_base, valor_aumento) * 100
    end
  end
end
