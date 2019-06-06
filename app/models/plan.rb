class Plan < ApplicationRecord

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :plan_name, presence: true, length: {maximum:20}

  # # プランパスワードのチェックは「40文字以下」だけ……未入力、「空欄というパスワード」でも登録可能
  # validates :password ,length: {maximum: 40}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user

  # 「参照するworkbox情報」を持つことができるだけ。
  # 持たないこともできるし、workboxが消えてもplanは消さない。
  belongs_to :workbox, optional: true

  #'acts_as_list'導入による変更
  has_many :plan_pins, -> { order(position: :asc) }
  # has_many :plan_pins, -> { order(position: :asc) } , dependent: :destroy
  
  # has_many :plan_pins , dependent: :destroy

  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
