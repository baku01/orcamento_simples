# typed: false
# frozen_string_literal: true

require "rails_helper"
require "sorbet-runtime"

VALOR_POR_HORA_EQP     = Float(25.85)
TOTAL_DE_HORAS_EQP     = Float(10)
DESPESAS_INDIRETA      = BigDecimal("1.0867")
MAGEM_DE_LUCRO_FIXA    = BigDecimal("0.1133")
IMPOSTO                = BigDecimal("0.1269")

VALOR_BASE             = BigDecimal("36.8520854931972")
VALOR_BASE_ADICIONAL   = BigDecimal("40.3245566310098")
VALOR_POR_HORA         = BigDecimal(10)
TOTAL_DE_HORAS         = Float(10)
TAXA_ESPERADA          = BigDecimal("0.34724711378126e1")

RSpec.describe(CalculadoraOrcamentariaService, type: :service) do
  context "quando calcular" do
    let(:valor_esperado_eqp) { BigDecimal("369.718281126612").to_f }
    let(:resultado_eqp) do
      described_class.valor_venda_eqp(
        valor_hora: VALOR_POR_HORA_EQP,
        despesa_indireta: DESPESAS_INDIRETA,
        margem_lucro_fixa: MAGEM_DE_LUCRO_FIXA,
        imposto: IMPOSTO,
        quantidade_horas: TOTAL_DE_HORAS_EQP,
      )
    end
    let(:valor_esperado_mo) { BigDecimal("71.5767968713234") * TOTAL_DE_HORAS }
    let(:resultado_mo) do
      described_class.valor_venda_mo(
        valor_hora: VALOR_POR_HORA,
        valor_base: VALOR_BASE,
        taxa_variacao: TAXA_ESPERADA,
        quantidade_horas: TOTAL_DE_HORAS,
      )
    end

    it "taxa de variação" do
      resultado = described_class.taxa_de_variacao_funcao(
        valor_base: VALOR_BASE,
        valor_base_adicional: VALOR_BASE_ADICIONAL,
      )
      expect(resultado).to(eq(TAXA_ESPERADA))
    end

    it "valor de venda da mão de obra" do
      expect(resultado_mo).to(be_within(0.000001).of(valor_esperado_mo))
    end

    it "valor de venda de equipamentos" do
      expect(resultado_eqp.to_f).to(be_within(0.000001).of(valor_esperado_eqp))
    end

    it "custos variáveis com margem de lucro" do
      resultado = described_class.custos_variaveis(
        valor_custo: BigDecimal("100.0"),
        margem_lucro: Float(0.25),
      )
      expect(resultado).to(eq(BigDecimal("125.00")))
    end
  end
end
