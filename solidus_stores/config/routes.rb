# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :trade_stores
  end
end
