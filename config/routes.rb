Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'users/show'
  root 'drawing_pins#index'

  resources :drawing_pins do
    collection do
      # ↓一覧画面での検索用
      get :index_search
      # ↓ワークボックスまたはプランから「追加」するか「削除」するか
      get :judge_add_or_remove

      # ↓map上に吹き出しを作成する
      get :make_speech_bubble
    end
    # member do
    # end
  end


  resources :workboxes, only: [:edit]
  resources :workbox_pins, only: [:create,:destroy] do
    collection do
      post :create_or_destroy_from_index
    end
  end



  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations"
  }
  # devise_for :users

  # ユーザープロフィール画面は独自に作成する
  resources :users, only: [:show,:edit,:update]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
