import { Controller } from "@hotwired/stimulus";

/**
 * Controller Stimulus responsável por gerenciar o formulário de proposta.
 * Realiza cálculos automáticos de valores com base nos campos preenchidos
 * e atualiza a interface em tempo real.
 */
export default class extends Controller {
  static targets = [
    "revisao",
    "horas",
    "valorHora",
    "despesas",
    "margemFixa",
    "margemAdicional",
    "valorBaseDisplay",
    "despesasDisplay",
    "margemFixaDisplay",
    "margemAdicionalDisplay",
    "valorTotalDisplay",
    "valorTotalHidden",
  ];

  connect() {
    this.calculate();
  }

  calculate() {
    // Obtém valores dos campos
    const horas = this.getNumber(this.horasTarget);
    const valorHora = this.getNumber(this.valorHoraTarget);
    const despesas = this.getNumber(this.despesasTarget);
    const margemFixa = this.getNumber(this.margemFixaTarget);
    const margemAdicional = this.getNumber(this.margemAdicionalTarget);

    // Validação dos campos
    this.validateField(this.horasTarget, horas < 0);
    this.validateField(this.valorHoraTarget, valorHora < 0);
    this.validateField(this.despesasTarget, despesas < 0);
    this.validateField(
      this.margemFixaTarget,
      margemFixa < 0 || margemFixa > 100,
    );
    this.validateField(
      this.margemAdicionalTarget,
      margemAdicional < 0 || margemAdicional > 100,
    );

    // Cálculos
    const valorBase = horas * valorHora;
    const valorMargemFixa = valorBase * (margemFixa / 100);
    const valorMargemAdicional = valorBase * (margemAdicional / 100);
    const valorTotal =
      valorBase + despesas + valorMargemFixa + valorMargemAdicional;

    // Atualiza displays
    this.updateDisplay(this.valorBaseDisplayTarget, valorBase);
    this.updateDisplay(this.despesasDisplayTarget, despesas);
    this.updateDisplay(this.margemFixaDisplayTarget, valorMargemFixa);
    this.updateDisplay(this.margemAdicionalDisplayTarget, valorMargemAdicional);
    this.updateDisplay(this.valorTotalDisplayTarget, valorTotal);

    // Atualiza campo oculto
    this.valorTotalHiddenTarget.value = valorTotal.toFixed(2);
  }

  /**
   * Valida um campo, adicionando/removendo a classe 'is-invalid' conforme a condição.
   */
  validateField(target, condition) {
    if (condition) {
      target.classList.add("is-invalid");
    } else {
      target.classList.remove("is-invalid");
    }
  }

  /**
   * Obtém e converte o valor de um campo para número, retornando 0 se inválido.
   */
  getNumber(target) {
    return parseFloat(target.value) || 0;
  }

  /**
   * Atualiza o conteúdo de um elemento de exibição com valor formatado em BRL.
   */
  updateDisplay(target, value) {
    target.textContent = this.formatCurrency(value);
  }

  /**
   * Formata um número como moeda brasileira (BRL).
   */
  formatCurrency(value) {
    return value.toLocaleString("pt-BR", {
      style: "currency",
      currency: "BRL",
    });
  }
}
