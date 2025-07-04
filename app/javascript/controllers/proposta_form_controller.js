/**
 * PropostaFormController - Versão Melhorada
 *
 * Controlador Stimulus responsável por gerenciar o formulário de proposta orçamentária
 * com funcionalidades avançadas de UX, performance e acessibilidade.
 *
 * @class PropostaFormController
 * @extends {Controller}
 * @version 3.0.0
 * @since 2024
 *
 * Funcionalidades:
 * - Cálculos em tempo real com debounce otimizado
 * - Busca e filtro de funções
 * - Salvamento automático de rascunhos
 * - Validação em tempo real
 * - Atalhos de teclado
 * - Animações suaves
 * - Feedback visual aprimorado
 * - Acessibilidade completa
 */

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    // Inputs principais
    "revisaoInput",
    "margemLucro",
    "searchInput",
    "draftData",

    // Rows e tabela
    "funcaoRow",
    "subtotalCell",
    "horasInput",
    "valorHoraInput",

    // Displays e contadores
    "valorBaseDisplay",
    "margemAdicionalDisplay",
    "valorTotalDisplay",
    "valorTotalHidden",
    "funcoesCounter",
    "funcoesCountText",
    "funcoesAtivasDisplay",
    "totalHorasDisplay",
    "funcoesMOIDisplay",
    "funcoesMODDisplay",
    "margemPercentDisplay",

    // Estados visuais
    "emptyState",
    "progressBar",
    "autoSaveIndicator",
    "alertContainer",

    // Botões e ações
    "submitBtn",
    "submitText",
    "submitLoading",
    "toggleAllBtn",
    "shortcutsPanel",

    // Validação
    "revisaoError",
    "margemLucroError",

    // Modal
    "confirmRevisao",
    "confirmMargem",
    "confirmTotal",
    "confirmFuncoes",
    "confirmHoras",

    // Loading
    "loadingOverlay",
    "toastContainer"
  ];

  static values = {
    autoSaveInterval: { type: Number, default: 30000 },
    debounceDelay: { type: Number, default: 300 },
    animationDuration: { type: Number, default: 200 }
  };

  /**
   * Inicialização do controlador
   */
  connect() {
    console.log("PropostaFormController v3.0 conectado");

    // Estado interno
    this.state = {
      calculations: {
        valorBase: 0,
        margemAdicional: 0,
        valorTotal: 0,
        totalHoras: 0,
        funcoesAtivas: 0,
        funcoesMOI: 0,
        funcoesMOD: 0
      },
      ui: {
        isCalculating: false,
        hasUnsavedChanges: false,
        searchTerm: '',
        shortcutsVisible: false
      },
      timers: {
        debounce: null,
        autoSave: null,
        progressAnimation: null
      }
    };

    // Inicializar componentes
    this.initializeComponent();
    this.setupEventListeners();
    this.startAutoSave();
    this.loadDraftIfExists();

    // Cálculo inicial
    this.updateCalculations();
  }

  /**
   * Limpeza quando o controlador é desconectado
   */
  disconnect() {
    this.clearAllTimers();
    console.log("PropostaFormController desconectado");
  }

  /**
   * Inicialização de componentes
   */
  initializeComponent() {
    // Configurar validação
    this.setupValidation();

    // Configurar formatação automática
    this.setupAutoFormatting();

    // Configurar acessibilidade
    this.setupAccessibility();

    // Configurar animações
    this.setupAnimations();
  }

  /**
   * Configurar listeners de eventos
   */
  setupEventListeners() {
    // Eventos customizados
    this.element.addEventListener('proposta-form:save-draft', this.saveDraft.bind(this));
    this.element.addEventListener('proposta-form:select-all', this.selectAllFunctions.bind(this));
    this.element.addEventListener('proposta-form:deselect-all', this.deselectAllFunctions.bind(this));

    // Eventos de visibilidade da página
    document.addEventListener('visibilitychange', this.handleVisibilityChange.bind(this));

    // Eventos de resize
    window.addEventListener('resize', this.debounce(this.handleResize.bind(this), 250));
  }

  /**
   * Configurar validação em tempo real
   */
  setupValidation() {
    const validationRules = {
      revisao: {
        required: true,
        min: 1,
        max: 999,
        message: 'Revisão deve ser entre 1 e 999'
      },
      margem_lucro: {
        required: true,
        min: 0,
        max: 100,
        message: 'Margem deve ser entre 0% e 100%'
      }
    };

    this.validationRules = validationRules;
  }

  /**
   * Configurar formatação automática
   */
  setupAutoFormatting() {
    // Formatação de campos monetários
    this.element.addEventListener('blur', (e) => {
      if (e.target.matches('[data-proposta-form-target="valorHoraInput"]')) {
        this.formatCurrencyInput(e);
      }
    });

    // Formatação de campos de horas
    this.element.addEventListener('blur', (e) => {
      if (e.target.matches('[data-proposta-form-target="horasInput"]')) {
        this.formatHoursInput(e);
      }
    });
  }

  /**
   * Configurar acessibilidade
   */
  setupAccessibility() {
    // Marcar regiões live
    this.markLiveRegions();

    // Configurar navegação por teclado
    this.setupKeyboardNavigation();

    // Configurar anúncios para screen readers
    this.setupScreenReaderAnnouncements();
  }

  /**
   * Configurar animações
   */
  setupAnimations() {
    // Configurar animações de entrada
    this.animateEntrance();

    // Configurar animações de transição
    this.setupTransitionAnimations();
  }

  /**
   * Marcar regiões live para screen readers
   */
  markLiveRegions() {
    if (this.hasValorTotalDisplayTarget) {
      this.valorTotalDisplayTarget.setAttribute('aria-live', 'polite');
      this.valorTotalDisplayTarget.setAttribute('aria-atomic', 'true');
    }

    if (this.hasFuncoesCountTextTarget) {
      this.funcoesCountTextTarget.setAttribute('aria-live', 'polite');
    }
  }

  /**
   * Configurar navegação por teclado
   */
  setupKeyboardNavigation() {
    // Implementar navegação por arrow keys na tabela
    this.element.addEventListener('keydown', (e) => {
      if (e.target.closest('.funcoes-table')) {
        this.handleTableKeyNavigation(e);
      }
    });
  }

  /**
   * Configurar anúncios para screen readers
   */
  setupScreenReaderAnnouncements() {
    this.announcements = {
      functionActivated: (nome) => `Função ${nome} ativada`,
      functionDeactivated: (nome) => `Função ${nome} desativada`,
      calculationUpdated: (total) => `Valor total atualizado para ${total}`,
      validationError: (field, message) => `Erro no campo ${field}: ${message}`
    };
  }

  /**
   * Animação de entrada
   */
  animateEntrance() {
    const cards = this.element.querySelectorAll('.form-section, .summary-section');
    cards.forEach((card, index) => {
      card.style.opacity = '0';
      card.style.transform = 'translateY(20px)';

      setTimeout(() => {
        card.style.transition = 'all 0.6s ease';
        card.style.opacity = '1';
        card.style.transform = 'translateY(0)';
      }, index * 100);
    });
  }

  /**
   * Configurar animações de transição
   */
  setupTransitionAnimations() {
    // Configurar animações para mudanças de valor
    this.setupValueChangeAnimations();

    // Configurar animações para estados de loading
    this.setupLoadingAnimations();
  }

  /**
   * Configurar animações de mudança de valor
   */
  setupValueChangeAnimations() {
    this.animateValueChange = (element, newValue, duration = 300) => {
      if (!element) return;

      element.style.transition = `all ${duration}ms ease`;
      element.classList.add('value-change');

      setTimeout(() => {
        if (typeof newValue === 'function') {
          newValue();
        } else {
          element.textContent = newValue;
        }

        setTimeout(() => {
          element.classList.remove('value-change');
        }, duration);
      }, duration / 2);
    };
  }

  /**
   * Configurar animações de loading
   */
  setupLoadingAnimations() {
    this.showLoading = (message = 'Carregando...') => {
      if (this.hasLoadingOverlayTarget) {
        this.loadingOverlayTarget.classList.add('active');
        const messageEl = this.loadingOverlayTarget.querySelector('h6');
        if (messageEl) messageEl.textContent = message;
      }
    };

    this.hideLoading = () => {
      if (this.hasLoadingOverlayTarget) {
        this.loadingOverlayTarget.classList.remove('active');
      }
    };
  }

  /**
   * Iniciar auto-save
   */
  startAutoSave() {
    if (this.autoSaveIntervalValue > 0) {
      this.state.timers.autoSave = setInterval(() => {
        if (this.state.ui.hasUnsavedChanges) {
          this.autoSave();
        }
      }, this.autoSaveIntervalValue);
    }
  }

  /**
   * Carregar rascunho se existir
   */
  loadDraftIfExists() {
    const draft = this.loadFromLocalStorage('proposta-draft');
    if (draft && draft.timestamp) {
      const draftAge = Date.now() - draft.timestamp;
      const maxAge = 24 * 60 * 60 * 1000; // 24 horas

      if (draftAge < maxAge) {
        this.showDraftPrompt(draft);
      }
    }
  }

  /**
   * Mostrar prompt de rascunho
   */
  showDraftPrompt(draft) {
    this.showToast(
      'Rascunho encontrado! Clique para carregar.',
      'info',
      10000,
      () => this.loadDraft(draft)
    );
  }

  /**
   * Toggle de linha da função
   */
  toggleRow(event) {
    const row = event.target.closest('tr');
    const isActive = event.target.checked;
    const inputs = row.querySelectorAll('input:not([type="checkbox"])');

    // Animação de ativação
    this.animateRowToggle(row, isActive);

    // Habilitar/desabilitar inputs
    inputs.forEach(input => {
      input.disabled = !isActive;
      if (isActive) {
        input.focus();
      }
    });

    // Atualizar classes
    row.classList.toggle('is-active', isActive);
    row.classList.toggle('is-inactive', !isActive);

    // Anunciar mudança
    const funcaoNome = row.dataset.funcaoNome;
    this.announceToScreenReader(
      isActive ?
        this.announcements.functionActivated(funcaoNome) :
        this.announcements.functionDeactivated(funcaoNome)
    );

    // Atualizar cálculos
    this.updateCalculationsDebounced();

    // Marcar como alterado
    this.markAsChanged();
  }

  /**
   * Animação de toggle da linha
   */
  animateRowToggle(row, isActive) {
    const duration = this.animationDurationValue;

    if (isActive) {
      row.style.transform = 'scale(1.02)';
      row.style.boxShadow = '0 4px 12px rgba(99, 102, 241, 0.15)';

      setTimeout(() => {
        row.style.transform = 'scale(1)';
        row.style.boxShadow = '';
      }, duration);
    } else {
      row.style.transform = 'scale(0.98)';
      setTimeout(() => {
        row.style.transform = 'scale(1)';
      }, duration);
    }
  }

  /**
   * Filtrar funções baseado na busca
   */
  filterFunctions(event) {
    const searchTerm = event.target.value.toLowerCase().trim();
    this.state.ui.searchTerm = searchTerm;

    let visibleCount = 0;
    let hiddenCount = 0;

    this.funcaoRowTargets.forEach(row => {
      const funcaoNome = row.dataset.funcaoNome?.toLowerCase() || '';
      const funcaoTipo = row.dataset.funcaoTipo?.toLowerCase() || '';
      const isVisible = !searchTerm ||
        funcaoNome.includes(searchTerm) ||
        funcaoTipo.includes(searchTerm);

      if (isVisible) {
        row.classList.remove('is-filtered-out');
        visibleCount++;
      } else {
        row.classList.add('is-filtered-out');
        hiddenCount++;
      }
    });

    // Mostrar/ocultar estado vazio
    this.toggleEmptyState(visibleCount === 0);

    // Anunciar resultado da busca
    if (searchTerm) {
      this.announceToScreenReader(
        `${visibleCount} funções encontradas para "${searchTerm}"`
      );
    }
  }

  /**
   * Limpar busca
   */
  clearSearch() {
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.value = '';
      this.searchInputTarget.dispatchEvent(new Event('input'));
      this.searchInputTarget.focus();
    }
  }

  /**
   * Selecionar todas as funções
   */
  selectAllFunctions() {
    const visibleRows = this.funcaoRowTargets.filter(row =>
      !row.classList.contains('is-filtered-out')
    );

    visibleRows.forEach(row => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      if (checkbox && !checkbox.checked) {
        checkbox.checked = true;
        checkbox.dispatchEvent(new Event('change'));
      }
    });

    this.showToast('Todas as funções foram selecionadas', 'success');
    this.announceToScreenReader('Todas as funções visíveis foram selecionadas');
  }

  /**
   * Desmarcar todas as funções
   */
  deselectAllFunctions() {
    this.funcaoRowTargets.forEach(row => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      if (checkbox && checkbox.checked) {
        checkbox.checked = false;
        checkbox.dispatchEvent(new Event('change'));
      }
    });

    this.showToast('Todas as funções foram desmarcadas', 'info');
    this.announceToScreenReader('Todas as funções foram desmarcadas');
  }

  /**
   * Selecionar apenas funções MOI
   */
  selectMOI() {
    this.selectFunctionsByType('moi');
  }

  /**
   * Selecionar apenas funções MOD
   */
  selectMOD() {
    this.selectFunctionsByType('mod');
  }

  /**
   * Selecionar funções por tipo
   */
  selectFunctionsByType(tipo) {
    // Primeiro desmarcar todas
    this.deselectAllFunctions();

    // Depois selecionar apenas do tipo especificado
    const targetRows = this.funcaoRowTargets.filter(row =>
      row.dataset.funcaoTipo === tipo && !row.classList.contains('is-filtered-out')
    );

    targetRows.forEach(row => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      if (checkbox) {
        checkbox.checked = true;
        checkbox.dispatchEvent(new Event('change'));
      }
    });

    this.showToast(`Funções ${tipo.toUpperCase()} selecionadas`, 'success');
    this.announceToScreenReader(`${targetRows.length} funções ${tipo.toUpperCase()} selecionadas`);
  }

  /**
   * Atualizar cálculos com debounce
   */
  updateCalculationsDebounced() {
    this.clearTimeout('debounce');
    this.state.timers.debounce = setTimeout(() => {
      this.updateCalculations();
    }, this.debounceDelayValue);
  }

  /**
   * Validar e atualizar
   */
  validateAndUpdate(event) {
    this.validateField(event);
    this.updateCalculationsDebounced();
    this.markAsChanged();
  }

  /**
   * Validar campo específico
   */
  validateField(event) {
    const field = event.target;
    const fieldName = field.name?.split('[').pop()?.replace(']', '');
    const rules = this.validationRules[fieldName];

    if (!rules) return;

    const value = parseFloat(field.value) || 0;
    let isValid = true;
    let errorMessage = '';

    // Validar obrigatoriedade
    if (rules.required && !field.value.trim()) {
      isValid = false;
      errorMessage = 'Este campo é obrigatório';
    }

    // Validar mínimo
    if (isValid && rules.min !== undefined && value < rules.min) {
      isValid = false;
      errorMessage = `Valor deve ser maior ou igual a ${rules.min}`;
    }

    // Validar máximo
    if (isValid && rules.max !== undefined && value > rules.max) {
      isValid = false;
      errorMessage = `Valor deve ser menor ou igual a ${rules.max}`;
    }

    // Aplicar classes de validação
    field.classList.toggle('is-invalid', !isValid);
    field.classList.toggle('is-valid', isValid && field.value.trim());

    // Mostrar erro
    const errorTarget = this[`${fieldName}ErrorTarget`];
    if (errorTarget) {
      errorTarget.textContent = errorMessage;
      errorTarget.style.display = errorMessage ? 'block' : 'none';
    }

    // Anunciar erro
    if (!isValid) {
      this.announceToScreenReader(this.announcements.validationError(fieldName, errorMessage));
    }

    return isValid;
  }

  /**
   * Atualizar cálculos principais
   */
  updateCalculations() {
    if (this.state.ui.isCalculating) return;

    this.state.ui.isCalculating = true;
    this.updateProgressBar(0);

    try {
      // Calcular valores
      const calculations = this.calculateValues();

      // Atualizar estado
      this.state.calculations = calculations;

      // Atualizar interface
      this.updateDisplays(calculations);

      // Atualizar progresso
      this.updateProgressBar(100);

      // Anunciar mudança
      this.announceCalculationUpdate(calculations);

    } catch (error) {
      console.error('Erro ao calcular valores:', error);
      this.showToast('Erro ao calcular valores', 'error');
    } finally {
      this.state.ui.isCalculating = false;
      setTimeout(() => this.updateProgressBar(0), 1000);
    }
  }

  /**
   * Calcular valores
   */
  calculateValues() {
    let valorBase = 0;
    let totalHoras = 0;
    let funcoesAtivas = 0;
    let funcoesMOI = 0;
    let funcoesMOD = 0;

    // Iterar sobre as funções ativas
    this.funcaoRowTargets.forEach(row => {
      const checkbox = row.querySelector('input[type="checkbox"]');
      if (!checkbox?.checked) return;

      const horasInput = row.querySelector('[data-proposta-form-target="horasInput"]');
      const valorHoraInput = row.querySelector('[data-proposta-form-target="valorHoraInput"]');
      const subtotalCell = row.querySelector('[data-proposta-form-target="subtotalCell"]');

      const horas = parseFloat(horasInput?.value) || 0;
      const valorHora = parseFloat(valorHoraInput?.value) || 0;
      const subtotal = horas * valorHora;

      // Atualizar subtotal na célula
      if (subtotalCell) {
        this.animateValueChange(subtotalCell, window.formatCurrency(subtotal));
        subtotalCell.classList.toggle('has-value', subtotal > 0);
      }

      // Acumular valores
      valorBase += subtotal;
      totalHoras += horas;
      funcoesAtivas++;

      // Contar por tipo
      const tipo = row.dataset.funcaoTipo;
      if (tipo === 'moi') funcoesMOI++;
      if (tipo === 'mod') funcoesMOD++;
    });

    // Calcular margem
    const margemPercent = parseFloat(this.margemLucroTarget?.value) || 0;
    const margemAdicional = valorBase * (margemPercent / 100);
    const valorTotal = valorBase + margemAdicional;

    return {
      valorBase,
      margemAdicional,
      valorTotal,
      totalHoras,
      funcoesAtivas,
      funcoesMOI,
      funcoesMOD,
      margemPercent
    };
  }

  /**
   * Atualizar displays
   */
  updateDisplays(calculations) {
    const {
      valorBase,
      margemAdicional,
      valorTotal,
      totalHoras,
      funcoesAtivas,
      funcoesMOI,
      funcoesMOD,
      margemPercent
    } = calculations;

    // Atualizar displays com animação
    if (this.hasValorBaseDisplayTarget) {
      this.animateValueChange(this.valorBaseDisplayTarget, window.formatCurrency(valorBase));
    }

    if (this.hasMargemAdicionalDisplayTarget) {
      this.animateValueChange(this.margemAdicionalDisplayTarget, window.formatCurrency(margemAdicional));
    }

    if (this.hasValorTotalDisplayTarget) {
      this.animateValueChange(this.valorTotalDisplayTarget, window.formatCurrency(valorTotal));
    }

    if (this.hasTotalHorasDisplayTarget) {
      this.animateValueChange(this.totalHorasDisplayTarget, window.formatHours(totalHoras));
    }

    if (this.hasFuncoesAtivasDisplayTarget) {
      this.animateValueChange(this.funcoesAtivasDisplayTarget, funcoesAtivas.toString());
    }

    if (this.hasFuncoesMOIDisplayTarget) {
      this.animateValueChange(this.funcoesMOIDisplayTarget, funcoesMOI.toString());
    }

    if (this.hasFuncoesMODDisplayTarget) {
      this.animateValueChange(this.funcoesMODDisplayTarget, funcoesMOD.toString());
    }

    if (this.hasMargemPercentDisplayTarget) {
      this.animateValueChange(this.margemPercentDisplayTarget, `(${margemPercent.toFixed(1)}%)`);
    }

    // Atualizar contador de funções
    this.updateFunctionCounter(funcoesAtivas);

    // Atualizar campo hidden
    if (this.hasValorTotalHiddenTarget) {
      this.valorTotalHiddenTarget.value = valorTotal.toFixed(2);
    }

    // Atualizar estado visual do botão
    this.updateSubmitButton(funcoesAtivas > 0);
  }

  /**
   * Atualizar contador de funções
   */
  updateFunctionCounter(count) {
    if (this.hasFuncoesCountTextTarget) {
      const text = count === 1 ? '1 função selecionada' : `${count} funções selecionadas`;
      this.animateValueChange(this.funcoesCountTextTarget, text);
    }

    if (this.hasFuncoesCounterTarget) {
      this.funcoesCounterTarget.classList.toggle('has-selection', count > 0);
    }
  }

  /**
   * Atualizar botão de submit
   */
  updateSubmitButton(hasSelection) {
    if (this.hasSubmitBtnTarget) {
      this.submitBtnTarget.disabled = !hasSelection;
      this.submitBtnTarget.classList.toggle('btn-success', hasSelection);
      this.submitBtnTarget.classList.toggle('btn-secondary', !hasSelection);
    }
  }

  /**
   * Atualizar barra de progresso
   */
  updateProgressBar(percentage) {
    if (this.hasProgressBarTarget) {
      this.progressBarTarget.style.width = `${percentage}%`;
      this.progressBarTarget.setAttribute('aria-valuenow', percentage);
    }
  }

  /**
   * Anunciar atualização de cálculo
   */
  announceCalculationUpdate(calculations) {
    const message = this.announcements.calculationUpdated(
      window.formatCurrency(calculations.valorTotal)
    );

    this.announceToScreenReader(message);
  }

  /**
   * Formatar input de moeda
   */
  formatCurrencyInput(event) {
    const input = event.target;
    const value = parseFloat(input.value) || 0;

    // Não formatar se o usuário ainda está digitando
    if (document.activeElement === input) return;

    // Formatar valor
    input.value = value.toFixed(2);
  }

  /**
   * Formatar input de horas
   */
  formatHoursInput(event) {
    const input = event.target;
    const value = parseFloat(input.value) || 0;

    // Não formatar se o usuário ainda está digitando
    if (document.activeElement === input) return;

    // Arredondar para 0.5
    const rounded = Math.round(value * 2) / 2;
    input.value = rounded.toFixed(1);
  }

  /**
   * Mostrar modal de confirmação
   */
  showConfirmation() {
    if (!this.validateForm()) return;

    // Atualizar dados do modal
    this.updateConfirmationModal();

    // Mostrar modal
    const modal = new bootstrap.Modal(document.getElementById('confirmModal'));
    modal.show();
  }

  /**
   * Atualizar modal de confirmação
   */
  updateConfirmationModal() {
    const { calculations } = this.state;

    if (this.hasConfirmRevisaoTarget) {
      this.confirmRevisaoTarget.textContent = this.revisaoInputTarget?.value || '—';
    }

    if (this.hasConfirmMargemTarget) {
      this.confirmMargemTarget.textContent = `${calculations.margemPercent.toFixed(1)}%`;
    }

    if (this.hasConfirmTotalTarget) {
      this.confirmTotalTarget.textContent = window.formatCurrency(calculations.valorTotal);
    }

    if (this.hasConfirmFuncoesTarget) {
      this.confirmFuncoesTarget.textContent = `${calculations.funcoesAtivas} funções`;
    }

    if (this.hasConfirmHorasTarget) {
      this.confirmHorasTarget.textContent = window.formatHours(calculations.totalHoras);
    }
  }

  /**
   * Validar formulário
   */
  validateForm() {
    let isValid = true;

    // Validar campos obrigatórios
    const requiredFields = [this.revisaoInputTarget, this.margemLucroTarget].filter(Boolean);

    requiredFields.forEach(field => {
      if (!this.validateField({ target: field })) {
        isValid = false;
      }
    });

    // Validar se há pelo menos uma função selecionada
    if (this.state.calculations.funcoesAtivas === 0) {
      this.showToast('Selecione pelo menos uma função', 'warning');
      isValid = false;
    }

    return isValid;
  }

  /**
   * Confirmar e enviar
   */
  confirmSubmit() {
    // Fechar modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
    if (modal) modal.hide();

    // Mostrar loading
    this.showLoading('Criando proposta...');

    // Desabilitar botão
    if (this.hasSubmitBtnTarget) {
      this.submitBtnTarget.disabled = true;
      this.submitTextTarget.classList.add('d-none');
      this.submitLoadingTarget.classList.remove('d-none');
    }

    // Simular delay para UX
    setTimeout(() => {
      // Limpar rascunho
      this.clearDraft();

      // Submeter formulário
      this.element.submit();
    }, 1000);
  }

  /**
   * Salvar rascunho
   */
  saveDraft() {
    const draftData = this.collectFormData();

    if (this.saveToLocalStorage('proposta-draft', {
      ...draftData,
      timestamp: Date.now()
    })) {
      this.showToast('Rascunho salvo com sucesso', 'success');
      this.showAutoSaveIndicator();
      this.state.ui.hasUnsavedChanges = false;
    } else {
      this.showToast('Erro ao salvar rascunho', 'error');
    }
  }

  /**
   * Auto-save
   */
  autoSave() {
    if (!this.state.ui.hasUnsavedChanges) return;

    this.saveDraft();
  }

  /**
   * Carregar rascunho
   */
  loadDraft(draft) {
    // Implementar carregamento de rascunho
    this.showToast('Rascunho carregado', 'success');
    this.updateCalculations();
  }

  /**
   * Limpar rascunho
   */
  clearDraft() {
    localStorage.removeItem('proposta-draft');
  }

  /**
   * Coletar dados do formulário
   */
  collectFormData() {
    const formData = {};

    // Coletar dados dos inputs
    const inputs = this.element.querySelectorAll('input, select, textarea');
    inputs.forEach(input => {
      if (input.name) {
        formData[input.name] = input.value;
      }
    });

    return formData;
  }

  /**
   * Mostrar indicador de auto-save
   */
  showAutoSaveIndicator() {
    if (this.hasAutoSaveIndicatorTarget) {
      this.autoSaveIndicatorTarget.classList.remove('d-none');
      setTimeout(() => {
        this.autoSaveIndicatorTarget.classList.add('d-none');
      }, 3000);
    }
  }

  /**
   * Marcar como alterado
   */
  markAsChanged() {
    this.state.ui.hasUnsavedChanges = true;
  }

  /**
   * Toggle do painel de atalhos
   */
  toggleShortcuts() {
    if (this.hasShortcutsPanelTarget) {
      this.shortcutsPanelTarget.classList.toggle('show');
      this.state.ui.shortcutsVisible = !this.state.ui.shortcutsVisible;
    }
  }

  /**
   * Utility functions
   */
  debounce(func, delay) {
    let timeoutId;
    return (...args) => {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => func.apply(this, args), delay);
    };
  }

  clearTimeout(timerName) {
    if (this.state.timers[timerName]) {
      clearTimeout(this.state.timers[timerName]);
      this.state.timers[timerName] = null;
    }
  }

  clearAllTimers() {
    Object.keys(this.state.timers).forEach(timerName => {
      this.clearTimeout(timerName);
    });
  }

  saveToLocalStorage(key, data) {
    return window.saveToLocalStorage(key, data);
  }

  loadFromLocalStorage(key) {
    return window.loadFromLocalStorage(key);
  }

  showToast(message, type = 'info', duration = 5000, callback = null) {
    window.showToast(message, type, duration);
    if (callback) {
      // Implementar callback se necessário
    }
  }

  announceToScreenReader(message) {
    const announcement = document.createElement('div');
    announcement.textContent = message;
    announcement.style.position = 'absolute';
    announcement.style.left = '-9999px';
    announcement.setAttribute('aria-live', 'polite');
    announcement.setAttribute('aria-atomic', 'true');

    document.body.appendChild(announcement);

    setTimeout(() => {
      document.body.removeChild(announcement);
    }, 1000);
  }

  toggleEmptyState(show) {
    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.classList.toggle('d-none', !show);
    }
  }

  handleVisibilityChange() {
    if (document.hidden) {
      // Página ficou oculta - salvar rascunho se necessário
      if (this.state.ui.hasUnsavedChanges) {
        this.autoSave();
      }
    }
  }

  handleResize() {
    // Implementar ajustes de responsividade se necessário
  }

  handleTableKeyNavigation(event) {
    // Implementar navegação por teclado na tabela
    const { key } = event;

    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(key)) {
      event.preventDefault();
      // Implementar lógica de navegação
    }
  }

  handleSubmit(event) {
    // Última validação antes do envio
    if (!this.validateForm()) {
      event.preventDefault();
      return false;
    }

    // Marcar como enviado
    this.state.ui.hasUnsavedChanges = false;
    return true;
  }
}
