Rails.application.routes.draw do
  root 'drawing_pins#index'
  get '/err', to: 'err#err'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # get 'users/show'

  resources :drawing_pins, only: [:index,:new,:edit,:create,:update,:destroy] do
    collection do
      # ↓一覧画面での検索用
      get :index_search
      # ↓ワークボックスまたはプランから「追加」するか「削除」するかの判断処理用
      get :judge_add_or_remove

      # ↓map上に吹き出しを作成する
      get :make_speech_bubble

      get :tutorial
    end
    # member do
    # end
  end

  resources :workboxes,only:[] do
  #↑二期開発でshowもココに追加する予定 resources :workboxes, only: [:show]
    resources :workbox_pins, only: [:create,:destroy]
  end

  resources :plans, only: [:show,:edit,:update] do
    member do
      get :presentation,:presentation_password
      post :presentation_password_chk
      # ↓一覧画面での検索用
      get :search_pin_for
      # ↓所属するpinについて、経路を一括で変更する
      patch :reset_pin_route
    end



    resources :plan_pins, only: [:show,:new,:edit,:update,:create,:destroy] do
    # resources :plan_pins, only: [:create,:destroy,:show,:new,:edit,:update] do
      collection do
        post :create_in_planform

      end
      member do
        delete :destroy_in_planform
      end
    end

  end

  # ドラッグアンドドロップによるプランピン並び替えの登録用
  patch 'plan/:id/sort', to: 'plans#sort'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: "users/registrations",
  }
  # devise_for :users

  # ユーザープロフィール画面は独自に作成する
  resources :users, only: [:show,:edit,:update]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :torisetu, only: [:index]

end
