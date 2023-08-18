Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]
  get 'administrator', to: 'administrator#index'
  telegram_webhook TelegramController

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
