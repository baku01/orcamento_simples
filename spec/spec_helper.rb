# typed: false
# frozen_string_literal: true

require "sorbet-runtime"
require "rspec/sorbet"

# Este arquivo foi gerado pelo comando `rails generate rspec:install`. Convencionalmente, todos
# os testes ficam em um diretório `spec`, que o RSpec adiciona ao `$LOAD_PATH`.
# O arquivo `.rspec` gerado contém `--require spec_helper`, o que faz com que
# este arquivo seja sempre carregado, sem a necessidade de requerê-lo explicitamente em
# outros arquivos.
#
# Dado que ele é sempre carregado, recomenda-se manter este arquivo o mais
# leve possível. Requisitar dependências pesadas neste arquivo
# aumentará o tempo de inicialização da sua suíte de testes em TODA execução, mesmo para um
# arquivo individual que pode não precisar de tudo isso carregado. Em vez disso, considere criar
# um arquivo auxiliar separado que requer as dependências adicionais e realiza
# a configuração extra, e então requerê-lo nos arquivos de teste que realmente precisam
# disso.
#
# Veja https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # Configuração do rspec-expectations vai aqui. Você pode usar uma biblioteca de
  # asserção/expectativa alternativa como wrong ou as asserções do stdlib/minitest se preferir.
  config.expect_with(:rspec) do |expectations|
    # Esta opção será padrão como `true` no RSpec 4. Ela faz com que a `description`
    # e a `failure_message` de matchers customizados incluam texto para métodos auxiliares
    # definidos usando `chain`, por exemplo:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "ser maior que 2 e menor que 4"
    # ...ao invés de:
    #     # => "ser maior que 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.color = true
  config.formatter = :documentation
  config.backtrace_exclusion_patterns = []

  # Configuração do rspec-mocks vai aqui. Você pode usar uma biblioteca de test double
  # alternativa (como bogus ou mocha) alterando a opção `mock_with` aqui.
  config.mock_with(:rspec) do |mocks|
    # Impede que você faça mock ou stub de um método que não existe em
    # um objeto real. Isso é geralmente recomendado, e será padrão
    # como `true` no RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Esta opção será padrão como `:apply_to_host_groups` no RSpec 4 (e não terá
  # como desativá-la -- a opção existe apenas para compatibilidade
  # retroativa no RSpec 3). Faz com que metadados de contexto compartilhado sejam
  # herdados pelo hash de metadados de grupos e exemplos, ao invés de
  # disparar inclusão automática implícita em grupos com metadados correspondentes.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # As configurações abaixo são sugeridas para fornecer uma boa experiência inicial
  # com o RSpec, mas sinta-se livre para customizar como quiser.
  #   # Isso permite limitar a execução de testes a exemplos ou grupos individuais
  #   # que você se importa, marcando-os com metadados `:focus`. Quando nada
  #   # está marcado com `:focus`, todos os exemplos são executados. O RSpec também fornece
  #   # aliases para `it`, `describe` e `context` que incluem metadados `:focus`:
  #   # `fit`, `fdescribe` e `fcontext`, respectivamente.
  #   config.filter_run_when_matching :focus
  #
  #   # Permite que o RSpec persista algum estado entre execuções para suportar
  #   # as opções de CLI `--only-failures` e `--next-failure`. Recomendamos
  #   # que você configure seu sistema de controle de versão para ignorar este arquivo.
  #   config.example_status_persistence_file_path = "spec/examples.txt"
  #
  #   # Limita a sintaxe disponível para a sintaxe sem monkey patching, que é
  #   # recomendada. Para mais detalhes, veja:
  #   # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  #   config.disable_monkey_patching!
  #
  #   # Muitos usuários do RSpec normalmente executam toda a suíte ou um arquivo
  #   # individual, e é útil permitir uma saída mais verbosa ao rodar um
  #   # arquivo de teste individual.
  #   if config.files_to_run.one?
  #     # Use o formatter de documentação para uma saída detalhada,
  #     # a menos que um formatter já tenha sido configurado
  #     # (por exemplo, via flag de linha de comando).
  #     config.default_formatter = "doc"
  #   end
  #
  #   # Imprime os 10 exemplos e grupos de exemplos mais lentos ao
  #   # final da execução dos testes, para ajudar a identificar quais testes estão
  #   # particularmente lentos.
  #   config.profile_examples = 10
  #
  #   # Executa os testes em ordem aleatória para expor dependências de ordem. Se você encontrar uma
  #   # dependência de ordem e quiser depurá-la, pode fixar a ordem fornecendo
  #   # a seed, que é impressa após cada execução.
  #   #     --seed 1234
  #   config.order = :random
  #
  #   # Semeia a randomização global neste processo usando a opção de CLI `--seed`.
  #   # Definir isso permite usar `--seed` para reproduzir determinísticamente
  #   # falhas de teste relacionadas à randomização passando o mesmo valor de `--seed`
  #   # que causou a falha.
  #   Kernel.srand config.seed
end
