class PlanPin < ApplicationRecord

  belongs_to :plan
  acts_as_list scope: :plan
  #'↑acts_as_list'導入に伴う追加記述

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :plan_pin_name, presence: true, length: {maximum:30}
  validates :plan_pin_article, length: {maximum:180}
  validates :plan_id,  uniqueness: { scope: :drawing_pin_id}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  before_validation :set_pin_info ,on: :create

  ####↓↓↓↓アソシエーション情報↓↓↓↓############

  #もとのピンが消えた場合、nullとあいて「情報が消されたという情報」は残す。
  belongs_to :drawing_pin, optional: true
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

  def set_pin_info
    #「プランピン」作成時、
    pin_info = DrawingPin.find_by(id: self.drawing_pin_id)

    if pin_info.present?
      self.plan_pin_name = pin_info.pin_name
      self.plan_pin_article = pin_info.pin_article
    end

  end

end
