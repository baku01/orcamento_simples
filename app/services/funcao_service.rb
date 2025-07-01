# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# == FuncaoService
#
# Serviço centralizado para operações de negócio relacionadas à entidade Funcao.
# Fornece uma camada de abstração entre controllers e modelos, centralizando
# a lógica de busca, validação e manipulação de funções orçamentárias.
#
# === Responsabilidades
# * Buscar funções por diferentes critérios
# * Validar existência e integridade de dados
# * Fornecer interface consistente para operações com funções
# * Centralizar tratamento de erros relacionados a funções
#
# === Módulos Internos
# * +BancoDeDados+: Operações diretas com persistência de dados
#
# === Padrões Utilizados
# * Service Object Pattern
# * Module Organization Pattern
# * Error Handling Centralization
#
# === Exemplos de uso
#   # Buscar função específica
#   funcao = FuncaoService::BancoDeDados.pega_funcao_por_id(id: 1)
#
#   # Obter valor base de forma segura
#   valor = FuncaoService::BancoDeDados.pega_valor_base(funcao)
#
#   # Listar todas as funções
#   funcoes = FuncaoService::BancoDeDados.pega_todas_funcoes
#
module FuncaoService
  # == BancoDeDados
  #
  # Módulo responsável por todas as operações de persistência relacionadas
  # à entidade Funcao. Centraliza queries, validações de existência e
  # tratamento de erros de banco de dados.
  #
  # === Responsabilidades
  # * Executar queries seguras com tratamento de erros
  # * Validar existência de registros antes de retornar
  # * Fornecer mensagens de erro consistentes
  # * Abstrair complexidade de ActiveRecord
  #
  # === Tratamento de Erros
  # * +ActiveRecord::RecordNotFound+: Quando registros não existem
  # * Validações de nulidade para campos obrigatórios
  # * Mensagens de erro padronizadas
  #
  # === Exemplos de uso
  #   # Buscar com tratamento de erro
  #   begin
  #     funcao = FuncaoService::BancoDeDados.pega_funcao_por_id(id: 999)
  #   rescue ActiveRecord::RecordNotFound => e
  #     puts e.message # => "Função não encontrada"
  #   end
  #
  #   # Obter valor base com validação
  #   funcao = Funcao.new(nome: "Teste", tipo: :moi) # sem valor_base
  #   begin
  #     valor = FuncaoService::BancoDeDados.pega_valor_base(funcao)
  #   rescue ActiveRecord::RecordNotFound => e
  #     puts e.message # => "Valor base não encontrado"
  #   end
  #
  module BancoDeDados
    class << self
      extend T::Sig

      # === Operações de Busca

      # Busca uma função específica pelo seu identificador único.
      #
      # Realiza busca segura no banco de dados com tratamento adequado
      # para casos onde o registro não existe, evitando exceptions não tratadas.
      #
      # @param id [Integer] Identificador único da função no banco de dados
      #
      # @return [Funcao] Instância da função encontrada
      #
      # @raise [ActiveRecord::RecordNotFound] Quando nenhuma função é encontrada com o ID fornecido
      # @raise [ArgumentError] Se o ID for nulo, negativo ou não numérico
      #
      # @example Buscar função existente
      #   funcao = FuncaoService::BancoDeDados.pega_funcao_por_id(id: 1)
      #   puts funcao.nome # => "ENGENHEIRO SENIOR"
      #
      # @example Tratar função inexistente
      #   begin
      #     funcao = FuncaoService::BancoDeDados.pega_funcao_por_id(id: 999)
      #   rescue ActiveRecord::RecordNotFound
      #     puts "Função não encontrada, redirecionando para listagem..."
      #   end
      #
      # @note Prefira este método ao invés de Funcao.find para melhor tratamento de erros
      #
      sig { params(id: Integer).returns(Funcao) }
      def pega_funcao_por_id(id:)
        raise ArgumentError, "ID deve ser um número positivo" if id <= 0

        funcao = Funcao.find_by(id: id)
        raise ActiveRecord::RecordNotFound, "Função não encontrada" if funcao.nil?

        funcao
      end

      # Recupera todas as funções cadastradas no sistema.
      #
      # Carrega todas as instâncias de Funcao do banco de dados, convertendo
      # para Array para facilitar manipulação e evitar lazy loading issues.
      #
      # @return [Array<Funcao>] Lista de todas as funções cadastradas (pode ser vazia)
      #
      # @example Listar todas as funções
      #   funcoes = FuncaoService::BancoDeDados.pega_todas_funcoes
      #   funcoes.each { |f| puts "#{f.nome} - #{f.tipo}" }
      #
      # @example Verificar se existem funções cadastradas
      #   funcoes = FuncaoService::BancoDeDados.pega_todas_funcoes
      #   if funcoes.empty?
      #     puts "Nenhuma função cadastrada"
      #   else
      #     puts "#{funcoes.size} funções encontradas"
      #   end
      #
      # @note Para grandes volumes de dados, considere implementar paginação
      #
      sig { returns(T::Array[Funcao]) }
      def pega_todas_funcoes
        Funcao.all.to_ary
      end

      # === Operações de Extração de Dados

      # Extrai o valor base de uma função com validação de nulidade.
      #
      # Acessa o campo valor_base de uma instância de Funcao, garantindo
      # que o valor existe e é válido antes de retornar. Essencial para
      # evitar erros em cálculos posteriores.
      #
      # @param funcao [Funcao] Instância da função da qual extrair o valor base
      #
      # @return [BigDecimal] Valor base da função
      #
      # @raise [ActiveRecord::RecordNotFound] Se o valor base for nulo ou não definido
      # @raise [ArgumentError] Se a função fornecida for nula
      #
      # @example Obter valor base para cálculos
      #   funcao = Funcao.find(1)
      #   valor_base = FuncaoService::BancoDeDados.pega_valor_base(funcao)
      #   # Usar valor_base em cálculos orçamentários...
      #
      # @example Validar função antes de usar valor
      #   funcao = Funcao.new(nome: "Teste") # sem valor_base definido
      #   begin
      #     valor = FuncaoService::BancoDeDados.pega_valor_base(funcao)
      #   rescue ActiveRecord::RecordNotFound
      #     puts "Função incompleta, valor base não definido"
      #   end
      #
      # @note Este método é preferível ao acesso direto para garantir validação
      #
      sig { params(funcao: Funcao).returns(BigDecimal) }
      def pega_valor_base(funcao)
        valor_base = funcao.valor_base
        raise ArgumentError, "Função não pode ser nula" if funcao.nil?

        raise ActiveRecord::RecordNotFound, "Valor base não encontrado" if valor_base.nil?

        valor_base
      end
    end
  end
end
