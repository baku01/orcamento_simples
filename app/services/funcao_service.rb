# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

# Serviço para lidar com lógicas relacionadas à entidade {Funcao}.
#
# Este módulo centraliza operações utilitárias e de negócio referentes à entidade {Funcao},
# facilitando a manutenção e reutilização de código relacionado a funções do sistema.
#
# @example Buscar uma função por ID
#   funcao = FuncaoService.pega_funcao_por_id(1)
#
# @example Buscar o valor base de uma função
#   valor_base = FuncaoService.pega_valor_base(funcao)
#
module FuncaoService
  # Módulo responsável por interações com o banco de dados relacionadas à entidade {Funcao}.
  #
  # Este módulo contém métodos utilitários para buscar funções e seus valores base no banco de dados.
  #
  # @example Buscar uma função por ID
  #   funcao = FuncaoService::BancoDeDados.pega_funcao_por_id(1)
  #
  # @example Buscar o valor base de uma função
  #   valor_base = FuncaoService::BancoDeDados.pega_valor_base(funcao)
  #
  module BancoDeDados
    class << self
      extend T::Sig

      # Busca uma instância de {Funcao} pelo seu ID.
      #
      # @param id [Integer] O ID da função a ser buscada.
      # @return [Funcao] A função encontrada.
      # @raise [ActiveRecord::RecordNotFound] Se nenhuma função for encontrada com o ID fornecido.
      sig { params(id: Integer).returns(Funcao) }
      def pega_funcao_por_id(id:)
        funcao = Funcao.find_by(id: id)
        raise ActiveRecord::RecordNotFound, "Função não encontrada" if funcao.nil?

        funcao
      end

      # Retorna o valor base associado a uma instância de {Funcao}.
      #
      # @param funcao [Funcao] A função da qual se deseja obter o valor base.
      # @return [BigDecimal] O valor base da função.
      # @raise [ActiveRecord::RecordNotFound] Se o valor base não estiver definido para a função.
      sig { params(funcao: Funcao).returns(BigDecimal) }
      def pega_valor_base(funcao)
        valor_base = funcao.valor_base
        raise ActiveRecord::RecordNotFound, "Valor base não encontrado" if valor_base.nil?

        valor_base
      end

      # Retorna todas as instâncias de {Funcao} presentes no banco de dados.
      #
      # @return [Array<Funcao>] Lista de todas as funções cadastradas.
      sig { returns(T::Array[Funcao]) }
      def pega_todas_funcoes
        Funcao.all.to_ary
      end
    end
  end
end
