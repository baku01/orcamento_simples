## 📋 Project Overview

**Current State**: ~35% complete Rails 8.0 budgeting system with structural issues
**Target State**: Complete, production-ready system with Tailwind CSS
**Estimated Implementation Time**: 3-4 weeks (structured in phases)

### 🏗️ Current Architecture
- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite (development), PostgreSQL-ready
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Custom CSS (TO BE REPLACED with Tailwind)
- **Typing**: Sorbet
- **Testing**: RSpec
- **Documentation**: YARD

## 🎯 Implementation Objectives

1. **Fix database schema inconsistencies**
2. **Replace custom CSS with Tailwind CSS**
3. **Complete missing CRUD operations**
4. **Implement responsive, modern UI**
5. **Add comprehensive test coverage**
6. **Ensure production readiness**

## 🚀 Phase 1: Foundation Setup (Week 1)

### Step 1.1: Install and Configure Tailwind CSS

```bash
# Add Tailwind CSS gem
bundle add tailwindcss-rails

# Install Tailwind
rails tailwindcss:install

# This will:
# - Add tailwindcss-rails to Gemfile
# - Create app/assets/stylesheets/application.tailwind.css
# - Update application.html.erb layout
# - Add build scripts to package.json
```

### Step 1.2: Remove Custom CSS Files

```bash
# Remove existing custom CSS files
rm -rf app/assets/stylesheets/application.css
rm -rf app/assets/stylesheets/**/*.css
rm -rf app/assets/stylesheets/**/*.scss

# Keep only Tailwind files:
# - app/assets/stylesheets/application.tailwind.css
```

### Step 1.3: Update Application Layout

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html class="h-full bg-gray-50">
  <head>
    <title>Sistema de Orçamentação</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body class="h-full">
    <!-- Navigation -->
    <nav class="bg-white shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <%= link_to "Sistema de Orçamentação", root_path,
                class: "text-xl font-semibold text-gray-900" %>
          </div>
          <div class="flex items-center space-x-4">
            <%= link_to "Propostas", propostas_path,
                class: "text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md" %>
            <%= link_to "Funções", funcoes_path,
                class: "text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md" %>
            <%= link_to "Equipamentos", equipamentos_path,
                class: "text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md" %>
          </div>
        </div>
      </div>
    </nav>

    <!-- Flash Messages -->
    <% if notice %>
      <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded mx-4 mt-4" role="alert">
        <%= notice %>
      </div>
    <% end %>

    <% if alert %>
      <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mx-4 mt-4" role="alert">
        <%= alert %>
      </div>
    <% end %>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <%= yield %>
    </main>
  </body>
</html>
```

### Step 1.4: Fix Database Schema

```bash
# Generate migration to fix schema issues
rails generate migration FixDatabaseSchema
```

```ruby
# db/migrate/[timestamp]_fix_database_schema.rb
class FixDatabaseSchema < ActiveRecord::Migration[8.0]
  def up
    # Rename main table if it still exists with wrong name
    if table_exists?(:funcaos) && !table_exists?(:funcoes)
      rename_table :funcaos, :funcoes
    end

    # Remove duplicate/unused tables
    drop_table :funcaos_propostas if table_exists?(:funcaos_propostas)
    drop_table :equipamentos_propostas if table_exists?(:equipamentos_propostas)

    # Create correct proposta_equipamentos table
    unless table_exists?(:proposta_equipamentos)
      create_table :proposta_equipamentos do |t|
        t.references :proposta, null: false, foreign_key: true
        t.references :equipamento, null: false, foreign_key: true
        t.decimal :horas_previstas, null: false, precision: 10, scale: 2
        t.timestamps
      end
    end

    # Add missing indexes for performance
    add_index :funcoes, :tipo unless index_exists?(:funcoes, :tipo)
    add_index :funcoes, :nome unless index_exists?(:funcoes, :nome)
    add_index :equipamentos, :nome unless index_exists?(:equipamentos, :nome)
    add_index :propostas, :revisao unless index_exists?(:propostas, :revisao)
  end

  def down
    drop_table :proposta_equipamentos if table_exists?(:proposta_equipamentos)
    remove_index :funcoes, :tipo if index_exists?(:funcoes, :tipo)
    remove_index :funcoes, :nome if index_exists?(:funcoes, :nome)
    remove_index :equipamentos, :nome if index_exists?(:equipamentos, :nome)
    remove_index :propostas, :revisao if index_exists?(:propostas, :revisao)
  end
end
```

```bash
# Run migration
rails db:migrate
```

### Step 1.5: Update Models with Correct Table Names and Relationships

```ruby
# app/models/funcao.rb
class Funcao < ApplicationRecord
  extend T::Sig

  self.table_name = 'funcoes'  # Ensure correct table name

  # Callbacks
  before_validation :formatar_nome

  # Relationships
  has_many :proposta_funcoes, class_name: 'PropostaFuncaoJoin', foreign_key: 'funcao_id', dependent: :destroy
  has_many :propostas, through: :proposta_funcoes

  # Enums
  enum :tipo, { moi: 0, mod: 1 }

  # Validations
  validates :nome, presence: true, length: { maximum: 25 }, uniqueness: { case_sensitive: false }
  validates :valor_base, presence: true, numericality: { greater_than: 0 }
  validates :valor_base_adicional, presence: true, numericality: { greater_than: 0 }
  validates :tipo, presence: true

  # Business methods
  sig { returns(BigDecimal) }
  def pega_taxa_variacao
    return BigDecimal("0") if valor_base.zero?
    valor_base_adicional / valor_base
  end

  private

  sig { void }
  def formatar_nome
    self.nome = nome&.upcase&.strip
  end
end
```

```ruby
# app/models/equipamento.rb
class Equipamento < ApplicationRecord
  extend T::Sig

  # Relationships
  has_many :proposta_equipamentos, dependent: :destroy
  has_many :propostas, through: :proposta_equipamentos

  # Validations
  validates :nome, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # Callbacks
  before_validation :formatar_nome

  private

  sig { void }
  def formatar_nome
    self.nome = nome&.upcase&.strip
  end
end
```

```ruby
# app/models/proposta_equipamento.rb
class PropostaEquipamento < ApplicationRecord
  extend T::Sig

  belongs_to :proposta
  belongs_to :equipamento

  validates :horas_previstas, presence: true, numericality: { greater_than: 0 }

  sig { returns(BigDecimal) }
  def valor_total
    (equipamento.valor_hora * horas_previstas).round(2)
  end
end
```

```ruby
# app/models/proposta.rb - Add missing relationships
class Proposta < ApplicationRecord
  extend T::Sig

  # Relationships
  has_many :proposta_funcoes, class_name: 'PropostaFuncaoJoin', dependent: :destroy
  has_many :funcoes, through: :proposta_funcoes
  has_many :proposta_equipamentos, dependent: :destroy
  has_many :equipamentos, through: :proposta_equipamentos

  # Validations
  validates :revisao, presence: true, numericality: { greater_than: 0 }
  validates :quantidade_horas, presence: true, numericality: { greater_than: 0 }
  validates :despesa_indireta, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro_fixa, presence: true, numericality: { greater_than: 0 }
  validates :margem_lucro, presence: true, numericality: { greater_than: 0 }
  validates :valor_total, presence: true, numericality: { greater_than: 0 }
  validates :valor_hora, presence: true, numericality: { greater_than: 0 }

  # Business methods
  sig { returns(BigDecimal) }
  def calcular_valor_base
    valor_funcoes = proposta_funcoes.sum { |pf| pf.valor_hora * pf.horas_previstas }
    valor_equipamentos = proposta_equipamentos.sum(&:valor_total)
    valor_funcoes + valor_equipamentos
  end
end
```

## 🚀 Phase 2: Controllers and Routes (Week 1-2)

### Step 2.1: Create Missing Controllers

```bash
# Generate EquipamentosController
rails generate controller Equipamentos index show new create edit update destroy --no-helper --no-assets
```

```ruby
# app/controllers/equipamentos_controller.rb
class EquipamentosController < ApplicationController
  extend T::Sig

  before_action :set_equipamento, only: [:show, :edit, :update, :destroy]

  sig { void }
  def index
    @equipamentos = Equipamento.all.order(:nome)
  end

  sig { void }
  def show
  end

  sig { void }
  def new
    @equipamento = Equipamento.new
  end

  sig { void }
  def create
    @equipamento = Equipamento.new(equipamento_params)

    if @equipamento.save
      redirect_to @equipamento, notice: 'Equipamento criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  sig { void }
  def edit
  end

  sig { void }
  def update
    if @equipamento.update(equipamento_params)
      redirect_to @equipamento, notice: 'Equipamento atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    @equipamento.destroy
    redirect_to equipamentos_url, notice: 'Equipamento removido com sucesso.'
  end

  private

  sig { void }
  def set_equipamento
    @equipamento = Equipamento.find(params[:id])
  end

  sig { returns(ActionController::Parameters) }
  def equipamento_params
    params.require(:equipamento).permit(:nome, :valor_hora)
  end
end
```

### Step 2.2: Update Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'propostas#index'

  resources :propostas do
    member do
      get :duplicate
    end
  end

  resources :funcoes
  resources :equipamentos

  # Health check
  get 'up' => 'rails/health#show', as: :rails_health_check
end
```

### Step 2.3: Complete PropostasController

```ruby
# app/controllers/propostas_controller.rb
class PropostasController < ApplicationController
  extend T::Sig

  before_action :set_proposta, only: [:show, :edit, :update, :destroy, :duplicate]

  sig { void }
  def index
    @propostas = Proposta.includes(:funcoes, :equipamentos).order(created_at: :desc)
  end

  sig { void }
  def show
  end

  sig { void }
  def new
    @proposta = Proposta.new
    @funcoes = Funcao.all.order(:nome)
    @equipamentos = Equipamento.all.order(:nome)
  end

  sig { void }
  def create
    @proposta = Proposta.new(proposta_params)

    if @proposta.save
      redirect_to @proposta, notice: 'Proposta criada com sucesso.'
    else
      @funcoes = Funcao.all.order(:nome)
      @equipamentos = Equipamento.all.order(:nome)
      render :new, status: :unprocessable_entity
    end
  end

  sig { void }
  def edit
    @funcoes = Funcao.all.order(:nome)
    @equipamentos = Equipamento.all.order(:nome)
  end

  sig { void }
  def update
    if @proposta.update(proposta_params)
      redirect_to @proposta, notice: 'Proposta atualizada com sucesso.'
    else
      @funcoes = Funcao.all.order(:nome)
      @equipamentos = Equipamento.all.order(:nome)
      render :edit, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    @proposta.destroy
    redirect_to propostas_url, notice: 'Proposta removida com sucesso.'
  end

  sig { void }
  def duplicate
    @new_proposta = @proposta.dup
    @new_proposta.revisao = @proposta.revisao + 1
    @new_proposta.save!

    # Duplicate associations
    @proposta.proposta_funcoes.each do |pf|
      @new_proposta.proposta_funcoes.create!(
        funcao: pf.funcao,
        valor_hora: pf.valor_hora,
        horas_previstas: pf.horas_previstas
      )
    end

    @proposta.proposta_equipamentos.each do |pe|
      @new_proposta.proposta_equipamentos.create!(
        equipamento: pe.equipamento,
        horas_previstas: pe.horas_previstas
      )
    end

    redirect_to @new_proposta, notice: 'Proposta duplicada com sucesso.'
  end

  private

  sig { void }
  def set_proposta
    @proposta = Proposta.find(params[:id])
  end

  sig { returns(ActionController::Parameters) }
  def proposta_params
    params.require(:proposta).permit(
      :revisao, :quantidade_horas, :despesa_indireta,
      :margem_lucro_fixa, :margem_lucro, :valor_total, :valor_hora
    )
  end
end
```

## 🚀 Phase 3: Views with Tailwind CSS (Week 2)

### Step 3.1: Create Shared Components

```erb
<!-- app/views/shared/_form_errors.html.erb -->
<% if object.errors.any? %>
  <div class="bg-red-50 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
    <div class="font-bold">
      <%= pluralize(object.errors.count, "erro") %> encontrado<%= "s" if object.errors.count > 1 %>:
    </div>
    <ul class="mt-2 ml-4 list-disc">
      <% object.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

```erb
<!-- app/views/shared/_page_header.html.erb -->
<div class="md:flex md:items-center md:justify-between mb-6">
  <div class="flex-1 min-w-0">
    <h2 class="text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate">
      <%= title %>
    </h2>
    <% if subtitle %>
      <div class="mt-1 flex flex-col sm:flex-row sm:flex-wrap sm:mt-0 sm:space-x-6">
        <div class="mt-2 flex items-center text-sm text-gray-500">
          <%= subtitle %>
        </div>
      </div>
    <% end %>
  </div>
  <div class="mt-4 flex md:mt-0 md:ml-4">
    <%= actions if local_assigns[:actions] %>
  </div>
</div>
```

### Step 3.2: Complete Propostas Views

```erb
<!-- app/views/propostas/index.html.erb -->
<%= render 'shared/page_header',
    title: 'Propostas',
    subtitle: "#{@propostas.count} proposta#{'s' if @propostas.count != 1}",
    actions: link_to('Nova Proposta', new_proposta_path,
             class: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium') %>

<div class="bg-white shadow overflow-hidden sm:rounded-md">
  <% if @propostas.any? %>
    <ul class="divide-y divide-gray-200">
      <% @propostas.each do |proposta| %>
        <li>
          <div class="px-4 py-4 sm:px-6 hover:bg-gray-50">
            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <div class="flex-shrink-0">
                  <div class="h-10 w-10 rounded-full bg-blue-500 flex items-center justify-center">
                    <span class="text-sm font-medium text-white">
                      #<%= proposta.id %>
                    </span>
                  </div>
                </div>
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">
                    Proposta #<%= proposta.id %> - Revisão <%= proposta.revisao %>
                  </div>
                  <div class="text-sm text-gray-500">
                    <%= proposta.funcoes.count %> função(ões) •
                    <%= proposta.equipamentos.count %> equipamento(s) •
                    <%= number_with_precision(proposta.quantidade_horas, precision: 1) %> horas
                  </div>
                </div>
              </div>
              <div class="flex items-center space-x-2">
                <div class="text-right">
                  <div class="text-sm font-medium text-gray-900">
                    <%= number_to_currency(proposta.valor_total) %>
                  </div>
                  <div class="text-sm text-gray-500">
                    <%= number_to_currency(proposta.valor_hora) %>/hora
                  </div>
                </div>
                <div class="flex space-x-2">
                  <%= link_to proposta, class: "text-blue-600 hover:text-blue-900" do %>
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                    </svg>
                  <% end %>
                  <%= link_to edit_proposta_path(proposta), class: "text-gray-400 hover:text-gray-600" do %>
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
  <% else %>
    <div class="text-center py-12">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
      </svg>
      <h3 class="mt-2 text-sm font-medium text-gray-900">Nenhuma proposta</h3>
      <p class="mt-1 text-sm text-gray-500">Comece criando uma nova proposta orçamentária.</p>
      <div class="mt-6">
        <%= link_to 'Nova Proposta', new_proposta_path,
            class: 'inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700' %>
      </div>
    </div>
  <% end %>
</div>
```

```erb
<!-- app/views/propostas/show.html.erb -->
<%= render 'shared/page_header',
    title: "Proposta ##{@proposta.id}",
    subtitle: "Revisão #{@proposta.revisao} • Criada em #{l(@proposta.created_at, format: :short)}",
    actions: content_for(:actions) %>

<% content_for :actions do %>
  <div class="flex space-x-3">
    <%= link_to 'Duplicar', duplicate_proposta_path(@proposta), method: :post,
        class: 'bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-md text-sm font-medium' %>
    <%= link_to 'Editar', edit_proposta_path(@proposta),
        class: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium' %>
    <%= link_to 'Excluir', @proposta, method: :delete,
        confirm: 'Tem certeza que deseja excluir esta proposta?',
        class: 'bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md text-sm font-medium' %>
  </div>
<% end %>

<!-- Resumo da Proposta -->
<div class="bg-white overflow-hidden shadow rounded-lg mb-6">
  <div class="px-4 py-5 sm:p-6">
    <div class="grid grid-cols-1 gap-5 sm:grid-cols-3">
      <div class="bg-blue-50 overflow-hidden shadow rounded-lg">
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">Valor Total</dt>
                <dd class="text-lg font-medium text-gray-900"><%= number_to_currency(@proposta.valor_total) %></dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-green-50 overflow-hidden shadow rounded-lg">
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">Total de Horas</dt>
                <dd class="text-lg font-medium text-gray-900"><%= number_with_precision(@proposta.quantidade_horas, precision: 1) %>h</dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-yellow-50 overflow-hidden shadow rounded-lg">
        <div class="p-5">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"></path>
              </svg>
            </div>
            <div class="ml-5 w-0 flex-1">
              <dl>
                <dt class="text-sm font-medium text-gray-500 truncate">Valor/Hora</dt>
                <dd class="text-lg font-medium text-gray-900"><%= number_to_currency(@proposta.valor_hora) %></dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Funções e Equipamentos -->
<div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
  <!-- Funções -->
  <div class="bg-white shadow rounded-lg">
    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
      <h3 class="text-lg leading-6 font-medium text-gray-900">Funções</h3>
      <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @proposta.funcoes.count %> função(ões) selecionada(s)</p>
    </div>
    <div class="px-4 py-5 sm:p-6">
      <% if @proposta.proposta_funcoes.any? %>
        <div class="space-y-4">
          <% @proposta.proposta_funcoes.includes(:funcao).each do |pf| %>
            <div class="flex justify-between items-center py-2 border-b border-gray-100 last:border-b-0">
              <div>
                <div class="text-sm font-medium text-gray-900"><%= pf.funcao.nome %></div>
                <div class="text-sm text-gray-500">
                  <%= pf.funcao.tipo.upcase %> •
                  <%= number_with_precision(pf.horas_previstas, precision: 1) %>h •
                  <%= number_to_currency(pf.valor_hora) %>/h
                </div>
              </div>
              <div class="text-right">
                <div class="text-sm font-medium text-gray-900">
                  <%= number_to_currency(pf.valor_hora * pf.horas_previstas) %>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      <% else %>
        <p class="text-gray-500 text-center py-4">Nenhuma função selecionada</p>
      <% end %>
    </div>
  </div>

  <!-- Equipamentos -->
  <div class="bg-white shadow rounded-lg">
    <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
      <h3 class="text-lg leading-6 font-medium text-gray-900">Equipamentos</h3>
      <p class="mt-1 max-w-2xl text-sm text-gray-500"><%= @proposta.equipamentos.count %> equipamento(s) selecionado(s)</p>
    </div>
    <div class="px-4 py-5 sm:p-6">
      <% if @proposta.proposta_equipamentos.any? %>
        <div class="space-y-4">
          <% @proposta.proposta_equipamentos.includes(:equipamento).each do |pe| %>
            <div class="flex justify-between items-center py-2 border-b border-gray-100 last:border-b-0">
              <div>
                <div class="text-sm font-medium text-gray-900"><%= pe.equipamento.nome %></div>
                <div class="text-sm text-gray-500">
                  <%= number_with_precision(pe.horas_previstas, precision: 1) %>h •
                  <%= number_to_currency(pe.equipamento.valor_hora) %>/h
                </div>
              </div>
              <div class="text-right">
                <div class="text-sm font-medium text-gray-900">
                  <%= number_to_currency(pe.valor_total) %>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      <% else %>
        <p class="text-gray-500 text-center py-4">Nenhum equipamento selecionado</p>
      <% end %>
    </div>
  </div>
</div>

<!-- Detalhes Financeiros -->
<div class="bg-white shadow rounded-lg mt-6">
  <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
    <h3 class="text-lg leading-6 font-medium text-gray-900">Detalhes Financeiros</h3>
  </div>
  <div class="px-4 py-5 sm:p-6">
    <dl class="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
      <div>
        <dt class="text-sm font-medium text-gray-500">Despesa Indireta</dt>
        <dd class="mt-1 text-sm text-gray-900"><%= number_to_currency(@proposta.despesa_indireta) %></dd>
      </div>
      <div>
        <dt class="text-sm font-medium text-gray-500">Margem de Lucro Fixa</dt>
        <dd class="mt-1 text-sm text-gray-900"><%= number_to_currency(@proposta.margem_lucro_fixa) %></dd>
      </div>
      <div>
        <dt class="text-sm font-medium text-gray-500">Margem de Lucro</dt>
        <dd class="mt-1 text-sm text-gray-900"><%= number_to_percentage(@proposta.margem_lucro, precision: 1) %></dd>
      </div>
      <div>
        <dt class="text-sm font-medium text-gray-500">Quantidade de Horas</dt>
        <dd class="mt-1 text-sm text-gray-900"><%= number_with_precision(@proposta.quantidade_horas, precision: 1) %></dd>
      </div>
    </dl>
  </div>
</div>
```

## 🚀 Phase 4: JavaScript/Stimulus Enhancement (Week 2-3)

### Step 4.1: Update Stimulus Controller for Propostas

```javascript
// app/javascript/controllers/proposta_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "funcaoRow",
    "equipamentoRow",
    "margemLucro",
    "valorBaseDisplay",
    "margemAdicionalDisplay",
    "valorTotalDisplay",
    "valorTotalHidden",
    "funcoesCounter",
    "equipamentosCounter",
    "submitBtn",
    "toggleAllFuncoes",
    "toggleAllEquipamentos"
  ]

  connect() {
    console.log("PropostaFormController connected")
    this.updateCalculations()
  }

  toggleFuncao(event) {
    const checkbox = event.target
    const row = checkbox.closest("[data-proposta-form-target='funcaoRow']")
    const horasInput = row.querySelector("input[name*='[horas_previstas]']")
    const valorHoraInput = row.querySelector("input[name*='[valor_hora]']")

    if (checkbox.checked) {
      row.classList.remove("opacity-50")
      horasInput.removeAttribute("disabled")
      valorHoraInput.removeAttribute("disabled")
      row.classList.add("bg-blue-50", "border-blue-200")
    } else {
      row.classList.add("opacity-50")
      horasInput.setAttribute("disabled", "disabled")
      valorHoraInput.setAttribute("disabled", "disabled")
      row.classList.remove("bg-blue-50", "border-blue-200")
    }

    this.updateCalculations()
  }

  toggleEquipamento(event) {
    const checkbox = event.target
    const row = checkbox.closest("[data-proposta-form-target='equipamentoRow']")
    const horasInput = row.querySelector("input[name*='[horas_previstas]']")

    if (checkbox.checked) {
      row.classList.remove("opacity-50")
      horasInput.removeAttribute("disabled")
      row.classList.add("bg-green-50", "border-green-200")
    } else {
      row.classList.add("opacity-50")
      horasInput.setAttribute("disabled", "disabled")
      row.classList.remove("bg-green-50", "border-green-200")
    }

    this.updateCalculations()
  }

  toggleAllFuncoes() {
    const checkboxes = this.funcaoRowTargets.map(row =>
      row.querySelector("input[type='checkbox']")
    )
    const allChecked = checkboxes.every(cb => cb.checked)

    checkboxes.forEach(checkbox => {
      checkbox.checked = !allChecked
      checkbox.dispatchEvent(new Event('change', { bubbles: true }))
    })
  }

  toggleAllEquipamentos() {
    const checkboxes = this.equipamentoRowTargets.map(row =>
      row.querySelector("input[type='checkbox']")
    )
    const allChecked = checkboxes.every(cb => cb.checked)

    checkboxes.forEach(checkbox => {
      checkbox.checked = !allChecked
      checkbox.dispatchEvent(new Event('change', { bubbles: true }))
    })
  }

  updateCalculations() {
    let valorBase = 0
    let totalHoras = 0
    let funcoesAtivas = 0
    let equipamentosAtivos = 0

    // Calcular funções ativas
    this.funcaoRowTargets.forEach(row => {
      const checkbox = row.querySelector("input[type='checkbox']")
      if (checkbox && checkbox.checked) {
        const horas = parseFloat(row.querySelector("input[name*='[horas_previstas]']").value) || 0
        const valorHora = parseFloat(row.querySelector("input[name*='[valor_hora]']").value) || 0

        valorBase += horas * valorHora
        totalHoras += horas
        funcoesAtivas++
      }
    })

    // Calcular equipamentos ativos
    this.equipamentoRowTargets.forEach(row => {
      const checkbox = row.querySelector("input[type='checkbox']")
      if (checkbox && checkbox.checked) {
        const horas = parseFloat(row.querySelector("input[name*='[horas_previstas]']").value) || 0
        const valorHora = parseFloat(row.dataset.valorHora) || 0

        valorBase += horas * valorHora
        totalHoras += horas
        equipamentosAtivos++
      }
    })

    // Calcular margem de lucro
    const margemPercent = parseFloat(this.margemLucroTarget.value) || 0
    const margemAdicional = valorBase * (margemPercent / 100)
    const valorTotal = valorBase + margemAdicional

    // Atualizar displays
    this.updateDisplay(this.valorBaseDisplayTarget, this.formatCurrency(valorBase))
    this.updateDisplay(this.margemAdicionalDisplayTarget, this.formatCurrency(margemAdicional))
    this.updateDisplay(this.valorTotalDisplayTarget, this.formatCurrency(valorTotal))

    // Atualizar campo hidden
    if (this.hasValorTotalHiddenTarget) {
      this.valorTotalHiddenTarget.value = valorTotal.toFixed(2)
    }

    // Atualizar contadores
    this.updateCounter(this.funcoesCounterTarget, funcoesAtivas, "função", "funções")
    this.updateCounter(this.equipamentosCounterTarget, equipamentosAtivos, "equipamento", "equipamentos")

    // Atualizar botão submit
    const canSubmit = funcoesAtivas > 0 && valorTotal > 0
    this.submitBtnTarget.disabled = !canSubmit
    this.submitBtnTarget.classList.toggle("opacity-50", !canSubmit)
    this.submitBtnTarget.classList.toggle("cursor-not-allowed", !canSubmit)
  }

  updateDisplay(target, value) {
    if (target && target.textContent !== value) {
      target.textContent = value
      this.animateUpdate(target)
    }
  }

  updateCounter(target, count, singular, plural) {
    if (!target) return

    const text = count === 0 ? `Nenhum ${singular} selecionado` :
                 count === 1 ? `1 ${singular} selecionado` :
                              `${count} ${plural} selecionados`

    target.textContent = text
    target.classList.toggle("text-gray-500", count === 0)
    target.classList.toggle("text-blue-600", count > 0)
  }

  formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value)
  }

  animateUpdate(element) {
    element.classList.add("scale-105", "text-blue-600")
    setTimeout(() => {
      element.classList.remove("scale-105", "text-blue-600")
    }, 200)
  }
}
```

## 🚀 Phase 5: Testing and Quality (Week 3-4)

### Step 5.1: Create Comprehensive Test Suite

```ruby
# spec/models/funcao_spec.rb
require 'rails_helper'

RSpec.describe Funcao, type: :model do
  describe 'validations' do
    subject { build(:funcao) }

    it { is_expected.to validate_presence_of(:nome) }
    it { is_expected.to validate_presence_of(:valor_base) }
    it { is_expected.to validate_presence_of(:valor_base_adicional) }
    it { is_expected.to validate_presence_of(:tipo) }
    it { is_expected.to validate_length_of(:nome).is_at_most(25) }
    it { is_expected.to validate_numericality_of(:valor_base).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:valor_base_adicional).is_greater_than(0) }
    it { is_expected.to validate_uniqueness_of(:nome).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:proposta_funcoes) }
    it { is_expected.to have_many(:propostas).through(:proposta_funcoes) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:tipo).with_values(moi: 0, mod: 1) }
  end

  describe 'callbacks' do
    it 'formats nome to uppercase' do
      funcao = build(:funcao, nome: 'engenheiro junior')
      funcao.valid?
      expect(funcao.nome).to eq('ENGENHEIRO JUNIOR')
    end

    it 'strips whitespace from nome' do
      funcao = build(:funcao, nome: '  engenheiro senior  ')
      funcao.valid?
      expect(funcao.nome).to eq('ENGENHEIRO SENIOR')
    end
  end

  describe '#pega_taxa_variacao' do
    it 'calculates correct variation rate' do
      funcao = build(:funcao, valor_base: 100, valor_base_adicional: 25)
      expect(funcao.pega_taxa_variacao).to eq(BigDecimal('0.25'))
    end

    it 'returns zero when valor_base is zero' do
      funcao = build(:funcao, valor_base: 0, valor_base_adicional: 25)
      expect(funcao.pega_taxa_variacao).to eq(BigDecimal('0'))
    end
  end
end
```

### Step 5.2: Create Factories

```ruby
# spec/factories/funcoes.rb
FactoryBot.define do
  factory :funcao do
    sequence(:nome) { |n| "FUNCAO #{n}" }
    valor_base { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    valor_base_adicional { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    tipo { %w[moi mod].sample }

    trait :moi do
      tipo { 'moi' }
    end

    trait :mod do
      tipo { 'mod' }
    end
  end
end

# spec/factories/equipamentos.rb
FactoryBot.define do
  factory :equipamento do
    sequence(:nome) { |n| "EQUIPAMENTO #{n}" }
    valor_hora { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end

# spec/factories/propostas.rb
FactoryBot.define do
  factory :proposta do
    revisao { 1 }
    quantidade_horas { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    despesa_indireta { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    margem_lucro_fixa { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    margem_lucro { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    valor_total { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    valor_hora { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
```

## 🚀 Implementation Commands

### Daily Commands to Run:
```bash
# 1. Install dependencies
bundle install

# 2. Setup Tailwind
rails tailwindcss:install

# 3. Run migrations
rails db:migrate

# 4. Generate sample data
rails db:seed

# 5. Build Tailwind CSS
rails tailwindcss:build

# 6. Start server
rails server

# 7. Run tests
rspec

# 8. Check code quality
rubocop -A
```

### File Structure Verification:
```bash
# Expected structure after implementation:
app/
├── assets/stylesheets/
│   └── application.tailwind.css
├── controllers/
│   ├── application_controller.rb
│   ├── equipamentos_controller.rb
│   ├── funcoes_controller.rb
│   └── propostas_controller.rb
├── javascript/
│   └── controllers/
│       └── proposta_form_controller.js
├── models/
│   ├── equipamento.rb
│   ├── funcao.rb
│   ├── proposta.rb
│   ├── proposta_equipamento.rb
│   └── proposta_funcao_join.rb
└── views/
    ├── layouts/
    │   └── application.html.erb
    ├── shared/
    │   ├── _form_errors.html.erb
    │   └── _page_header.html.erb
    ├── equipamentos/
    ├── funcoes/
    └── propostas/
```

## 🎯 Validation Checklist

### After Implementation Verify:
- [ ] All migrations run successfully
- [ ] Tailwind CSS compiles without errors
- [ ] All models have proper validations and relationships
- [ ] All controllers have complete CRUD operations
- [ ] All views render properly with Tailwind styling
- [ ] JavaScript calculations work correctly
- [ ] Tests pass with >90% coverage
- [ ] No N+1 queries in index pages
- [ ] Responsive design works on mobile
- [ ] Forms handle validation errors gracefully

### Performance Targets:
- [ ] Index pages load in <200ms
- [ ] Form submissions complete in <100ms
- [ ] No console errors in browser
- [ ] Lighthouse score >90 for performance
- [ ] Database queries optimized with proper includes

This comprehensive guide should enable complete implementation of the budgeting system with modern Tailwind CSS styling and full functionality.
