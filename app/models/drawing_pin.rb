class DrawingPin < ApplicationRecord

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :pin_name, presence: true, length: {maximum:30}
  validates :pin_article, length: {maximum:180}
  validates :address, length: {maximum:255}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user, optional: true

  #もとのピンが消えた場合、nullに変更して「情報が消されたという情報」は残す。
  has_many :workbox_pins , dependent: :nullify
  has_many :plan_pins , dependent: :nullify
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
