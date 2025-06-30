/**
 * PropostaFormController
 *
 * Controlador Stimulus responsável por gerenciar o formulário de proposta orçamentária.
 * Permite ativar/desativar funções, calcular subtotais, margem de lucro e valores totais,
 * além de atualizar a interface com os valores formatados em moeda brasileira.
 *
 * Alvos esperados (Stimulus targets):
 * - funcaoRow: linhas da tabela de funções (cada função/orçamento)
 * - margemLucro: input para percentual de margem de lucro
 * - valorBaseDisplay: elemento para exibir o valor base total
 * - margemAdicionalDisplay: elemento para exibir o valor da margem de lucro
 * - valorTotalDisplay: elemento para exibir o valor total final
 * - valorTotalHidden: input hidden para armazenar o valor total (para submissão do formulário)
 *
 * Estrutura esperada do HTML:
 * - Cada linha de função (tr) deve conter:
 *   - Um checkbox para ativar/desativar a função
 *   - Dois inputs numéricos: um para horas e outro para valor/hora
 *   - Uma célula com a classe "subtotal-cell" para exibir o subtotal calculado
 * - Inputs e displays para margem de lucro, valor base, margem adicional, valor total e valor total oculto
 *
 * Eventos esperados:
 * - toggleRow: disparado ao clicar no checkbox de uma função
 * - update: disparado ao alterar valores de horas, valor/hora ou margem de lucro
 */

import { Controller } from "@hotwired/stimulus";

/**
 * Classe PropostaFormController
 *
 * Responsável por controlar o formulário de proposta orçamentária, realizando cálculos
 * dinâmicos de subtotais, margem de lucro e total, além de atualizar a interface conforme
 * as interações do usuário.
 */
export default class extends Controller {
  /**
   * Lista de targets (alvos) utilizados pelo controlador.
   *
   * @type {string[]}
   */
  static targets = [
    "funcaoRow", // Linhas da tabela de funções
    "margemLucro", // Input de percentual de margem de lucro
    "valorBaseDisplay", // Elemento para exibir o valor base total
    "margemAdicionalDisplay", // Elemento para exibir o valor da margem de lucro
    "valorTotalDisplay", // Elemento para exibir o valor total final
    "valorTotalHidden", // Input hidden para armazenar o valor total
  ];

  /**
   * Formata um número como moeda brasileira (BRL).
   *
   * @param {number} value - Valor numérico a ser formatado.
   * @returns {string} Valor formatado como moeda BRL.
   */
  formatCurrency(value) {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(value);
  }

  /**
   * Ativa ou desativa uma linha da tabela de funções quando o checkbox é clicado.
   * Habilita/desabilita os inputs de número e limpa os valores ao desativar.
   *
   * @param {Event} event - Evento de clique no checkbox.
   *
   * Fluxo:
   * - Se o checkbox for marcado, ativa a linha e habilita os inputs de número.
   * - Se desmarcado, desativa a linha, limpa e desabilita os inputs de número.
   * - Após qualquer alteração, chama update() para recalcular os valores.
   */
  toggleRow(event) {
    const row = event.target.closest("tr");
    const inputs = row.querySelectorAll('input[type="number"]');

    if (event.target.checked) {
      row.classList.add("is-active");
      inputs.forEach((input) => (input.disabled = false)); // Desbloqueia inputs
    } else {
      row.classList.remove("is-active");
      inputs.forEach((input) => {
        input.value = "";
        input.disabled = true; // Bloqueia inputs
      });
    }
    this.update(); // Recalcula todos os valores após alteração
  }

  /**
   * Função principal que atualiza todos os cálculos do orçamento.
   * Soma subtotais das funções ativas, calcula margem de lucro e valor total,
   * e atualiza a interface com os valores formatados.
   *
   * Fluxo:
   * - Percorre todas as linhas de função (funcaoRowTargets).
   * - Para cada linha ativa (checkbox marcado):
   *   - Obtém os valores de horas e valor/hora.
   *   - Calcula o subtotal (horas * valor/hora).
   *   - Soma ao valor base total.
   *   - Atualiza a célula de subtotal com o valor formatado.
   * - Para linhas inativas, exibe "—" na célula de subtotal.
   * - Calcula a margem adicional (percentual sobre o valor base).
   * - Calcula o valor total (valor base + margem adicional).
   * - Atualiza os elementos de exibição e o input hidden com os valores calculados.
   */
  update() {
    let valorBase = 0;

    // Percorre todas as linhas de função para calcular subtotais
    this.funcaoRowTargets.forEach((row) => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      const subtotalCell = row.querySelector(".subtotal-cell");

      if (checkbox.checked) {
        // Obtém inputs de horas e valor/hora
        const [horasInput, valorHoraInput] = row.querySelectorAll(
          'input[type="number"]',
        );
        const horas = parseFloat(horasInput.value) || 0;
        const valorHora = parseFloat(valorHoraInput.value) || 0;
        const subtotal = horas * valorHora;

        valorBase += subtotal;
        subtotalCell.textContent = this.formatCurrency(subtotal);
      } else {
        subtotalCell.textContent = "—";
      }
    });

    // Calcula margem de lucro e valor total
    const margemPercentual = parseFloat(this.margemLucroTarget.value) || 0;
    const margemAdicional = valorBase * (margemPercentual / 100);
    const valorTotal = valorBase + margemAdicional;

    // Atualiza a interface com os valores formatados
    this.valorBaseDisplayTarget.textContent = this.formatCurrency(valorBase);
    this.margemAdicionalDisplayTarget.textContent =
      this.formatCurrency(margemAdicional);
    this.valorTotalDisplayTarget.textContent = this.formatCurrency(valorTotal);
    this.valorTotalHiddenTarget.value = valorTotal.toFixed(2);
  }
}
