/**
 * PropostaFormController
 *
 * Controlador Stimulus responsável por gerenciar o formulário de proposta orçamentária.
 * Permite ativar/desativar funções, calcular subtotais, margem de lucro e valores totais,
 * além de atualizar a interface com os valores formatados em moeda brasileira.
 *
 * @class PropostaFormController
 * @extends {Controller} - Controlador base do Stimulus
 *
 * @description
 * Este controlador gerencia formulários de proposta orçamentária permitindo:
 * - Ativar/desativar funções específicas via checkbox
 * - Calcular subtotais baseados em horas e valor/hora
 * - Aplicar margem de lucro sobre o valor base
 * - Atualizar valores em tempo real conforme interação do usuário
 * - Formatar valores monetários em Real brasileiro (BRL)
 *
 * @requires @hotwired/stimulus
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
 * Eventos esperados (actions):
 * - toggleRow: disparado ao clicar no checkbox de uma função
 * - update: disparado ao alterar valores de horas, valor/hora ou margem de lucro
 *
 * @example
 * // Exemplo de uso no HTML:
 * <div data-controller="proposta-form">
 *   <table>
 *     <tr data-proposta-form-target="funcaoRow">
 *       <td><input type="checkbox" data-action="change->proposta-form#toggleRow"></td>
 *       <td><input type="number" data-action="input->proposta-form#update"></td>
 *       <td><input type="number" data-action="input->proposta-form#update"></td>
 *       <td class="subtotal-cell">—</td>
 *     </tr>
 *   </table>
 *   <input type="number" data-proposta-form-target="margemLucro" data-action="input->proposta-form#update">
 *   <span data-proposta-form-target="valorBaseDisplay"></span>
 *   <span data-proposta-form-target="margemAdicionalDisplay"></span>
 *   <span data-proposta-form-target="valorTotalDisplay"></span>
 *   <input type="hidden" data-proposta-form-target="valorTotalHidden">
 * </div>
 *
 * @author Sistema de Orçamentos
 * @version 1.0.0
 * @since 2024
 */

import { Controller } from "@hotwired/stimulus";

/**
 * Classe PropostaFormController
 *
 * Responsável por controlar o formulário de proposta orçamentária, realizando cálculos
 * dinâmicos de subtotais, margem de lucro e total, além de atualizar a interface conforme
 * as interações do usuário.
 *
 * @class
 * @extends {Controller}
 */
export default class extends Controller {
  /**
   * Lista de targets (alvos) utilizados pelo controlador.
   * Define os elementos HTML que serão controlados por este controlador Stimulus.
   *
   * @static
   * @type {string[]}
   * @memberof PropostaFormController
   *
   * @description
   * - funcaoRow: Array de elementos <tr> representando cada função/linha do orçamento
   * - margemLucro: Input numérico para definir o percentual de margem de lucro
   * - valorBaseDisplay: Elemento de exibição (span/div) para mostrar o valor base
   * - margemAdicionalDisplay: Elemento de exibição para mostrar o valor da margem
   * - valorTotalDisplay: Elemento de exibição para mostrar o valor total
   * - valorTotalHidden: Input hidden para enviar o valor total no formulário
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
   * Utiliza a API Intl.NumberFormat para formatação padronizada.
   *
   * @method formatCurrency
   * @param {number} value - Valor numérico a ser formatado
   * @returns {string} Valor formatado como moeda BRL (ex: "R$ 1.234,56")
   *
   * @example
   * formatCurrency(1234.56) // retorna "R$ 1.234,56"
   * formatCurrency(0) // retorna "R$ 0,00"
   * formatCurrency(-500) // retorna "-R$ 500,00"
   *
   * @throws {TypeError} Se o valor não for um número válido
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
   * Esta função é chamada automaticamente quando o evento 'change' é disparado no checkbox.
   *
   * @method toggleRow
   * @param {Event} event - Evento de clique/mudança no checkbox
   * @param {HTMLInputElement} event.target - O checkbox que foi clicado
   *
   * @description
   * Fluxo de execução:
   * 1. Identifica a linha (tr) pai do checkbox clicado
   * 2. Localiza todos os inputs numéricos da linha
   * 3. Se checkbox marcado:
   *    - Adiciona classe CSS "is-active" à linha
   *    - Habilita todos os inputs numéricos
   * 4. Se checkbox desmarcado:
   *    - Remove classe CSS "is-active" da linha
   *    - Limpa valores dos inputs numéricos
   *    - Desabilita todos os inputs numéricos
   * 5. Chama update() para recalcular todos os valores
   *
   * @example
   * // No HTML:
   * <input type="checkbox" data-action="change->proposta-form#toggleRow">
   *
   * @fires update - Dispara recálculo automático após alteração
   * @see {@link update} - Método responsável por recalcular valores
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
   * @method update
   * @public
   *
   * @description
   * Esta é a função central do controlador, responsável por:
   * 1. Calcular subtotais de cada função ativa
   * 2. Somar todos os subtotais para obter o valor base
   * 3. Calcular a margem de lucro baseada no percentual definido
   * 4. Calcular o valor total (valor base + margem)
   * 5. Atualizar todos os elementos de exibição na interface
   * 6. Atualizar o campo hidden para submissão do formulário
   *
   * Fluxo detalhado:
   * - Percorre todas as linhas de função (funcaoRowTargets)
   * - Para cada linha ativa (checkbox marcado):
   *   - Obtém os valores de horas e valor/hora dos inputs
   *   - Calcula o subtotal (horas × valor/hora)
   *   - Soma ao valor base total
   *   - Atualiza a célula de subtotal com o valor formatado
   * - Para linhas inativas, exibe "—" na célula de subtotal
   * - Calcula a margem adicional (percentual sobre o valor base)
   * - Calcula o valor total (valor base + margem adicional)
   * - Atualiza os elementos de exibição e o input hidden com os valores calculados
   *
   * @example
   * // Chamada manual (opcional, normalmente é automática):
   * this.update();
   *
   * // Resultado esperado na interface:
   * // Valor Base: R$ 5.000,00
   * // Margem (10%): R$ 500,00
   * // Total: R$ 5.500,00
   *
   * @fires None - Não dispara eventos, apenas atualiza a interface
   * @see {@link formatCurrency} - Usado para formatar valores monetários
   *
   * @performance
   * Complexidade: O(n) onde n é o número de linhas de função
   * A função é otimizada para executar rapidamente em tempo real
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
