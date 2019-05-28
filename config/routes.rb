Rails.application.routes.draw do

  root 'drawing_pins#index'

  resources :drawing_pins

  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
