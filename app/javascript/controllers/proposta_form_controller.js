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
 * - Validação em tempo real
 * - Estados de loading e confirmação
 * - Formatação automática de campos
 *
 * @requires @hotwired/stimulus
 * @version 2.0.0
 * @since 2024
 */

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  /**
   * Lista de targets (alvos) utilizados pelo controlador.
   * Define os elementos HTML que serão controlados por este controlador Stimulus.
   */
  static targets = [
    "funcaoRow",                  // Linhas da tabela de funções
    "margemLucro",               // Input de percentual de margem de lucro
    "valorBaseDisplay",          // Elemento para exibir o valor base total
    "margemAdicionalDisplay",    // Elemento para exibir o valor da margem de lucro
    "valorTotalDisplay",         // Elemento para exibir o valor total final
    "valorTotalHidden",          // Input hidden para armazenar o valor total
    "funcoesCounter",            // Contador de funções selecionadas
    "funcoesCountText",          // Texto do contador
    "emptyState",                // Estado vazio
    "submitBtn",                 // Botão de submit
    "submitText",                // Texto do botão submit
    "submitLoading",             // Estado de loading do submit
    "toggleAllBtn",              // Botão para selecionar todas
    "subtotalCell",              // Células de subtotal
    "funcoesAtivasDisplay",      // Display de funções ativas
    "totalHorasDisplay",         // Display de total de horas
    "margemPercentDisplay",      // Display do percentual de margem
    "revisaoError",              // Erro do campo revisão
    "margemLucroError",          // Erro do campo margem
    "confirmRevisao",            // Modal - revisão
    "confirmMargem",             // Modal - margem
    "confirmTotal",              // Modal - total
    "confirmFuncoes"             // Modal - funções
  ];

  /**
   * Inicialização do controlador
   */
  connect() {
    console.log("PropostaFormController conectado");
    this.updateTimeout = null; // Para debounce
    this.initializeTooltips();
    this.setupKeyboardNavigation();
    this.update(); // Atualiza cálculos iniciais
  }

  /**
   * Atualização com debounce para melhor performance
   */
  updateWithDebounce() {
    if (this.updateTimeout) {
      clearTimeout(this.updateTimeout);
    }
    this.updateTimeout = setTimeout(() => this.update(), 150); // 150ms de debounce para melhor responsividade
  }

  /**
   * Manipula teclas especiais nos inputs
   */
  handleKeydown(event) {
    // Enter - vai para próximo campo
    if (event.key === 'Enter') {
      event.preventDefault();
      this.focusNextInput(event.target);
      return;
    }

    // Tab - força atualização imediata
    if (event.key === 'Tab') {
      this.update();
    }
  }

  /**
   * Inicializa tooltips do Bootstrap
   */
  initializeTooltips() {
    const tooltipTriggerList = this.element.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltipTriggerList.forEach(tooltipTriggerEl => {
      new bootstrap.Tooltip(tooltipTriggerEl);
    });
  }

  /**
   * Configura navegação por teclado
   */
  setupKeyboardNavigation() {
    this.element.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' && event.target.matches('input[type="number"]')) {
        event.preventDefault();
        this.focusNextInput(event.target);
      }
    });
  }

  /**
   * Move foco para próximo input
   */
  focusNextInput(currentInput) {
    const inputs = Array.from(this.element.querySelectorAll('input:not([disabled])'));
    const currentIndex = inputs.indexOf(currentInput);
    const nextInput = inputs[currentIndex + 1];
    if (nextInput) {
      nextInput.focus();
    }
  }

  /**
   * Formata um número como moeda brasileira (BRL).
   */
  formatCurrency(value) {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(value || 0);
  }

  /**
   * Formata horas
   */
  formatHours(value) {
    const hours = parseFloat(value) || 0;
    if (hours === 0) return "0h";
    if (hours === 1) return "1h";
    return `${hours}h`;
  }

  /**
   * Formata percentual
   */
  formatPercent(value) {
    const percent = parseFloat(value) || 0;
    return `${percent.toFixed(2)}%`;
  }

  /**
   * Anima alteração de valor
   */
  animateValueChange(element) {
    element.classList.add('value-change');
    setTimeout(() => {
      element.classList.remove('value-change');
    }, 500);
  }

  /**
   * Ativa ou desativa uma linha da tabela de funções
   */
  toggleRow(event) {
    const row = event.target.closest("tr");
    const inputs = row.querySelectorAll('input[type="number"]');
    const isChecked = event.target.checked;

    // Adiciona/remove classes visuais
    if (isChecked) {
      row.classList.add("is-active");
      row.classList.remove("is-inactive");
      inputs.forEach((input) => {
        input.disabled = false;
        // Se não tem valor, adiciona valor padrão mais realista
        if (!input.value && input.name.includes('quantidade_horas')) {
          input.value = "8"; // 8 horas como padrão mais realista
          input.focus(); // Foca no campo para facilitar edição
        }
      });
    } else {
      row.classList.remove("is-active");
      row.classList.add("is-inactive");
      inputs.forEach((input) => {
        input.value = "";
        input.disabled = true;
      });
    }

    this.update();
    this.updateToggleAllButton();
  }


  /**
   * Alterna todas as funções
   */
  toggleAllFunctions(event) {
    const checkboxes = this.funcaoRowTargets.map(row =>
      row.querySelector('input[type="checkbox"]')
    );

    const allChecked = checkboxes.every(cb => cb.checked);
    const newState = !allChecked;

    checkboxes.forEach(checkbox => {
      if (checkbox.checked !== newState) {
        checkbox.checked = newState;
        // Dispara evento para cada checkbox
        const changeEvent = new Event('change', { bubbles: true });
        checkbox.dispatchEvent(changeEvent);
      }
    });

    this.updateToggleAllButton();
  }

  /**
   * Atualiza o botão "Selecionar Todas"
   */
  updateToggleAllButton() {
    if (!this.hasToggleAllBtnTarget) return;

    const checkboxes = this.funcaoRowTargets.map(row =>
      row.querySelector('input[type="checkbox"]')
    );
    const checkedCount = checkboxes.filter(cb => cb.checked).length;
    const allChecked = checkedCount === checkboxes.length;

    const btn = this.toggleAllBtnTarget;
    const icon = btn.querySelector('i');
    const text = btn.lastChild;

    if (allChecked) {
      btn.classList.remove('btn-outline-primary');
      btn.classList.add('btn-outline-danger');
      icon.className = 'bi bi-x-square me-1';
      text.textContent = ' Desmarcar Todas';
    } else {
      btn.classList.remove('btn-outline-danger');
      btn.classList.add('btn-outline-primary');
      icon.className = 'bi bi-check2-all me-1';
      text.textContent = ' Selecionar Todas';
    }
  }

  /**
   * Valida campo individual
   */
  validateField(event) {
    const field = event.target;
    const value = field.value;
    let isValid = true;
    let errorMessage = '';

    // Validação específica por campo
    if (field === this.margemLucroTarget) {
      if (!value || value < 0 || value > 100) {
        isValid = false;
        errorMessage = 'Margem deve estar entre 0% e 100%';
      }
    }

    // Campos obrigatórios
    if (field.hasAttribute('required') && !value) {
      isValid = false;
      errorMessage = 'Este campo é obrigatório';
    }

    // Atualiza estado visual
    if (isValid) {
      field.classList.remove('is-invalid');
      field.classList.add('is-valid');
    } else {
      field.classList.remove('is-valid');
      field.classList.add('is-invalid');
    }

    // Mostra/esconde mensagem de erro
    const errorTarget = field.name === 'proposta[revisao]' ?
      this.revisaoErrorTarget : this.margemLucroErrorTarget;

    if (errorTarget) {
      errorTarget.textContent = errorMessage;
    }

    return isValid;
  }

  /**
   * Formata campo de moeda ao sair do campo
   */
  formatCurrencyInput(event) {
    const input = event.target;
    const value = parseFloat(input.value) || 0;

    // Não formata se estiver vazio ou inválido
    if (!input.value) return;

    // Formata com 2 casas decimais
    input.value = value.toFixed(2);
  }

  /**
   * Formata campo de horas ao sair do campo
   */
  formatHoursInput(event) {
    const input = event.target;
    const value = parseFloat(input.value) || 0;

    if (!input.value) return;

    // Formata com 1 casa decimal se necessário
    input.value = value % 1 === 0 ? value.toString() : value.toFixed(1);
  }

  /**
   * Função principal que atualiza todos os cálculos do orçamento.
   */
  update() {
    let valorBase = 0;
    let totalHoras = 0;
    let funcoesAtivas = 0;

    // Percorre todas as linhas de função para calcular subtotais
    this.funcaoRowTargets.forEach((row) => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      const subtotalCell = row.querySelector(".subtotal-cell");

      if (checkbox && checkbox.checked) {
        funcoesAtivas++;

        // Obtém inputs de horas e valor/hora
        const inputs = row.querySelectorAll('input[type="number"]');
        const horasInput = inputs[0]; // primeiro input = horas
        const valorHoraInput = inputs[1]; // segundo input = valor/hora

        const horas = parseFloat(horasInput?.value) || 0;
        const valorHora = parseFloat(valorHoraInput?.value) || 0;
        const subtotal = horas * valorHora;

        valorBase += subtotal;
        totalHoras += horas;

        if (subtotalCell) {
          subtotalCell.textContent = this.formatCurrency(subtotal);
          subtotalCell.classList.add('has-value');
          this.animateValueChange(subtotalCell);
        }
      } else {
        if (subtotalCell) {
          subtotalCell.textContent = "—";
          subtotalCell.classList.remove('has-value');
        }
      }
    });

    // Calcula margem de lucro e valor total
    const margemPercentual = parseFloat(this.margemLucroTarget?.value) || 0;
    const margemAdicional = valorBase * (margemPercentual / 100);
    const valorTotal = valorBase + margemAdicional;

    // Atualiza displays principais
    this.updateDisplay(this.valorBaseDisplayTarget, this.formatCurrency(valorBase));
    this.updateDisplay(this.margemAdicionalDisplayTarget, this.formatCurrency(margemAdicional));
    this.updateDisplay(this.valorTotalDisplayTarget, this.formatCurrency(valorTotal));

    // Atualiza displays adicionais
    if (this.hasFuncoesAtivasDisplayTarget) {
      this.updateDisplay(this.funcoesAtivasDisplayTarget, funcoesAtivas.toString());
    }

    if (this.hasTotalHorasDisplayTarget) {
      this.updateDisplay(this.totalHorasDisplayTarget, this.formatHours(totalHoras));
    }

    if (this.hasMargemPercentDisplayTarget) {
      this.updateDisplay(this.margemPercentDisplayTarget, `(${this.formatPercent(margemPercentual)})`);
    }

    // Atualiza campo hidden
    if (this.hasValorTotalHiddenTarget) {
      this.valorTotalHiddenTarget.value = valorTotal.toFixed(2);
    }

    // Atualiza contador de funções
    this.updateFuncoesCounter(funcoesAtivas);

    // Controla estado vazio
    this.toggleEmptyState(funcoesAtivas === 0);

    // Atualiza estado do botão submit
    this.updateSubmitButton(funcoesAtivas > 0 && valorTotal > 0);
  }

  /**
   * Atualiza display com animação
   */
  updateDisplay(target, value) {
    if (target && target.textContent !== value) {
      target.textContent = value;
      this.animateValueChange(target);
    }
  }

  /**
   * Atualiza contador de funções
   */
  updateFuncoesCounter(count) {
    if (!this.hasFuncoesCounterTarget) return;

    const counter = this.funcoesCounterTarget;
    const text = this.funcoesCountTextTarget;

    if (count === 0) {
      text.textContent = "Nenhuma função selecionada";
      counter.classList.remove('has-selection');
    } else if (count === 1) {
      text.textContent = "1 função selecionada";
      counter.classList.add('has-selection');
    } else {
      text.textContent = `${count} funções selecionadas`;
      counter.classList.add('has-selection');
    }

    // Animação visual do contador quando há mudança
    counter.style.transform = 'scale(1.05)';
    setTimeout(() => {
      counter.style.transform = 'scale(1)';
    }, 150);
  }


  /**
   * Controla exibição do estado vazio
   */
  toggleEmptyState(isEmpty) {
    if (!this.hasEmptyStateTarget) return;

    const emptyState = this.emptyStateTarget;
    const table = this.element.querySelector('.funcoes-table');

    if (isEmpty) {
      emptyState.classList.remove('d-none');
      table?.classList.add('d-none');
    } else {
      emptyState.classList.add('d-none');
      table?.classList.remove('d-none');
    }
  }

  /**
   * Atualiza estado do botão submit
   */
  updateSubmitButton(enabled) {
    if (!this.hasSubmitBtnTarget) return;

    const btn = this.submitBtnTarget;
    btn.disabled = !enabled;

    if (!enabled) {
      btn.setAttribute('title', 'Selecione pelo menos uma função para continuar');
    } else {
      btn.removeAttribute('title');
    }
  }

  /**
   * Mostra modal de confirmação
   */
  showConfirmation(event) {
    event.preventDefault();

    // Valida formulário primeiro
    if (!this.validateForm()) {
      return;
    }

    // Atualiza dados do modal
    this.updateConfirmationModal();

    // Mostra modal
    const modal = new bootstrap.Modal(document.getElementById('confirmModal'));
    modal.show();
  }

  /**
   * Valida formulário completo
   */
  validateForm() {
    let isValid = true;

    // Valida campos obrigatórios
    const requiredFields = this.element.querySelectorAll('input[required]');
    requiredFields.forEach(field => {
      const fieldValid = this.validateField({ target: field });
      if (!fieldValid) isValid = false;
    });

    // Verifica se há funções selecionadas
    const funcoesAtivas = this.funcaoRowTargets.filter(row =>
      row.querySelector('input[type="checkbox"]')?.checked
    ).length;

    if (funcoesAtivas === 0) {
      alert('Selecione pelo menos uma função para continuar.');
      isValid = false;
    }

    return isValid;
  }

  /**
   * Atualiza dados do modal de confirmação
   */
  updateConfirmationModal() {
    if (this.hasConfirmRevisaoTarget) {
      const revisao = this.element.querySelector('input[name="proposta[revisao]"]')?.value || '-';
      this.confirmRevisaoTarget.textContent = revisao;
    }

    if (this.hasConfirmMargemTarget) {
      const margem = this.margemLucroTarget?.value || '0';
      this.confirmMargemTarget.textContent = `${margem}%`;
    }

    if (this.hasConfirmTotalTarget) {
      this.confirmTotalTarget.textContent = this.valorTotalDisplayTarget?.textContent || 'R$ 0,00';
    }

    if (this.hasConfirmFuncoesTarget) {
      const funcoesAtivas = this.funcaoRowTargets.filter(row =>
        row.querySelector('input[type="checkbox"]')?.checked
      ).length;
      this.confirmFuncoesTarget.textContent = `${funcoesAtivas} função(ões) selecionada(s)`;
    }
  }

  /**
   * Confirma e submete o formulário
   */
  confirmSubmit() {
    this.showLoadingState();

    // Submete o formulário
    setTimeout(() => {
      this.element.querySelector('form')?.submit();
    }, 500);
  }

  /**
   * Mostra estado de loading
   */
  showLoadingState() {
    // Mostra overlay de loading
    const loadingOverlay = document.getElementById('loadingOverlay');
    if (loadingOverlay) {
      loadingOverlay.classList.add('active');
    }

    // Atualiza botão
    if (this.hasSubmitBtnTarget && this.hasSubmitTextTarget && this.hasSubmitLoadingTarget) {
      this.submitBtnTarget.disabled = true;
      this.submitTextTarget.classList.add('d-none');
      this.submitLoadingTarget.classList.remove('d-none');
    }

    // Fecha modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
    if (modal) {
      modal.hide();
    }
  }

  /**
   * Método chamado quando o controlador é desconectado
   */
  disconnect() {
    console.log("PropostaFormController desconectado");

    // Limpa tooltips
    const tooltips = this.element.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltips.forEach(element => {
      const tooltip = bootstrap.Tooltip.getInstance(element);
      if (tooltip) {
        tooltip.dispose();
      }
    });
  }
}
