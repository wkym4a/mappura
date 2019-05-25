Rails.application.routes.draw do

  root 'drawing_pins#test'

  resources :drawing_pins

  devise_for :users

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
