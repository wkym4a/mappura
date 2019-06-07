Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'users/show'
  root 'drawing_pins#index'

  resources :drawing_pins, only: [:index,:new,:edit,:create,:update,:destroy] do
    collection do
      # ↓一覧画面での検索用
      get :index_search
      # ↓ワークボックスまたはプランから「追加」するか「削除」するかの判断処理用
      get :judge_add_or_remove

      # ↓map上に吹き出しを作成する
      get :make_speech_bubble
    end
    # member do
    # end
  end


  resources :workboxes, only: [:show]
  resources :workbox_pins, only: [:create,:destroy]

  resources :plans, only: [:show,:edit,:update] do
    member do
      get :presentation
      # ↓一覧画面での検索用
      get :search_pin_for
    end

    resources :plan_pins, only: [:create,:destroy,:edit,:update,:show,:new] do
    end

  end
  resources :plan_pins, only: [:create,:destroy] do
    collection do
      post :create_in_planform
    end
    member do
      delete :destroy_in_planform
    end
  end

  # ドラッグアンドドロップによるプランピン並び替えの登録用
  patch 'plan/:id/sort', to: 'plans#sort'

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
