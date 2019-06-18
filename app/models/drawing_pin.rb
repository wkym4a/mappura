class DrawingPin < ApplicationRecord

  #「image」列を、画像アップローダと紐付ける
  mount_uploader :image, ImageUploader

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :pin_name, presence: true, length: {maximum:30}
  validates :pin_article, length: {maximum:180}
  validates :address, length: {maximum:255}
  validates :latitude, numericality: {greater_than_or_equal_to: -90,less_than_or_equal_to: 90}
  validates :longitude, numericality: {greater_than_or_equal_to: -180,less_than_or_equal_to: 180}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user, optional: true

  #もとのピンが消えた場合、nullに変更して「情報が消されたという情報」は残す。
  has_many :workbox_pins , dependent: :nullify
  has_many :plan_pins , dependent: :nullify
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
