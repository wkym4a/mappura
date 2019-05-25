class Workbox < ApplicationRecord

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :workbox_name, presence: true, length: {maximum:12}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user

  # planは「参照するworkbox情報」を持つことができるだけ。
  # 持たないこともできるし、workboxが消えてもplanは消さない。
  has_many :plans , dependent: :nullify

  has_many :workbox_pins , dependent: :destroy
  ####↑↑↑↑アソシエーション情報↑↑↑↑############


end
