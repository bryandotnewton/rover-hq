# frozen_string_literal: true

Rails.application.routes.draw do
  resources :commands, only: %w[create show]
  get '/', to: 'commands#new'
  root 'commands#new'
end
