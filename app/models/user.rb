class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #削除時にメール送信など行う可能性があるため、delete_allは使わない
  has_many :drawing_pins , dependent: :destroy
  has_many :workboxes , dependent: :destroy
  has_many :plans , dependent: :destroy
end
