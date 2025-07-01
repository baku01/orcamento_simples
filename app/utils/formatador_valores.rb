# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# Converte um valor numérico (Float, Integer, String ou BigDecimal) para BigDecimal,
# garantindo precisão em operações financeiras e monetárias.
#
# @param valor [Float, Integer, String, BigDecimal] O valor a ser convertido.
# @return [BigDecimal] O valor convertido para BigDecimal.
module FormatadorValores
  class << self
    extend T::Sig

    # Converte um valor numérico (Float, Integer, String ou BigDecimal) para BigDecimal.
    #
    # @param valor [Float, Integer, String, BigDecimal] O valor a ser convertido.
    # @return [BigDecimal] O valor convertido para BigDecimal.
    sig { params(valor: T.any(Float, Integer, String, BigDecimal)).returns(BigDecimal) }
    def para_bigdecimal(valor)
      BigDecimal(valor.to_s)
    end

    # Converte um valor numérico (Float, Integer, String ou BigDecimal) para Float.
    #
    # @param valor [Float, Integer, String, BigDecimal] O valor a ser convertido.
    # @return [Float] O valor convertido para Float.
    sig { params(valor: T.any(Float, Integer, String, BigDecimal)).returns(Float) }
    def para_float(valor)
      valor.to_f
    end

    # Converte uma string para letras maiúsculas, se presente.
    #
    # @param texto [String] O texto a ser convertido.
    # @return [String, nil] O texto convertido para maiúsculas, ou nil se o texto não estiver presente.
    sig { params(texto: String).returns(T.nilable(String)) }
    def para_uppercase(texto:)
      return if texto.blank?

      texto.upcase
    end
  end
end
