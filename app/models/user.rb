class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :user_name, presence: true,uniqueness: true, length: { maximum: 40 }
  validates :account_name, length: { maximum: 20 }
  validates :profile, length: { maximum: 280 }

  validate :check_number_of_workboxes ,on: :update

  def check_number_of_workboxes

    workbox_count = self.workboxes.count{ |workbox| workbox._destroy == false}
    if workbox_count > 4
      errors.add(:workbox,"の登録上限数は、4個です。")
    end

    plan_count = self.plans.count{ |plan| plan._destroy == false}
    if plan_count > 24
      errors.add(:plan,"の登録上限数は、24個です。")
    end


  end
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  #削除時にメール送信など行う可能性があるため、delete_allは使わない
  has_many :drawing_pins , dependent: :destroy
  has_many :workboxes , dependent: :destroy
  has_many :plans , dependent: :destroy

  # 一般ユーザーは「対象となる権限レコードなし」の状態とする。
  #ただし権限レコードの削除時は「その権限を有するユーザーがいない」ことが条件
  # (権限削除によって、勝手に一般ユーザーに戻ることはないように)。
  belongs_to :role, optional: true

  # nestedfieldの使用にあたり、↓を追記
  accepts_nested_attributes_for :workboxes, allow_destroy: true
  accepts_nested_attributes_for :plans, allow_destroy: true

  ####↑↑↑↑アソシエーション情報↑↑↑↑############


  #DBに登録してある「（ユーザー情報）公開区分」情報（integer型）から、対応する名称を取得する
  def self.get_public_div_name(n)
      case n
      when 0 then
        return "公開"
      when 9 then
        return "非公開"

      else
        return "不正な値です"
      end

  end

  #DBに登録してある「メールアドレス公開区分」情報（integer型）から、対応する名称を取得する
  def self.get_email_public_div_name(n)
      case n
      when 0 then
        return "公開"
      when 9 then
        return "非公開"

      else
        return "不正な値です"
      end

  end

  #DBに登録してある「ピン公開区分（デフォルト）」情報（integer型）から、対応する名称を取得する
  def self.get_pin_public_div_name(n)
      case n
      when 0 then
        return "公開"
      when 9 then
        return "非公開"

      else
        return "不正な値です"
      end

  end




end
