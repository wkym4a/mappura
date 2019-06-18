class Plan < ApplicationRecord
  has_secure_password validations: false

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :plan_name, presence: true, length: {maximum:20}

  # プランパスワードのチェックは「40文字以下」だけ……未入力チェックは「chk_password_existence」で行う
  validates :password ,length: {maximum: 40}

  #パスワードの存在確認……
  validate :chk_password_existence, on: :update

  def chk_password_existence

    case self.public_div
    when 0
      # 「公開」にする場合はパスワードを空にする
      self.password_digest = nil
    when 9
      # 「非公開」にする場合はパスワード必須（なければエラー）
      errors.add(:password,"「非公開」にする場合はパスワードを設定してください。") if self.password_digest.blank?
    end
  end
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :user

  # 「参照するworkbox情報」を持つことができるだけ。
  # 持たないこともできるし、workboxが消えてもplanは消さない。
  belongs_to :workbox, optional: true

  #'acts_as_list'導入による変更
  has_many :plan_pins, -> { order(position: :asc) }, dependent: :destroy
  # has_many :plan_pins, dependent: :destroy

  # has_many :plan_pins, -> { order(position: :asc) }

  # has_many :plan_pins, -> { order(position: :asc) } , dependent: :destroy

  # has_many :plan_pins , dependent: :destroy

  ####↑↑↑↑アソシエーション情報↑↑↑↑############



end
