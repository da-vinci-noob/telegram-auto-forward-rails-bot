Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "users/omniauth_callback", sessions: 'users/sessions' }, skip: [:registrations]
  devise_for :admins, skip: [:registrations]
  get 'administrator', to: 'administrator#index'
  telegram_webhook TelegramController

  resources :home, only: %i[update]
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
