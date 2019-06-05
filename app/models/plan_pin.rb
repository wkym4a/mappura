class PlanPin < ApplicationRecord

  ####↓↓↓↓バリデーション情報↓↓↓↓############
  validates :plan_pin_name, presence: true, length: {maximum:30}
  validates :plan_pin_article, length: {maximum:180}
  validates :plan_id,  uniqueness: { scope: :drawing_pin_id}
  ####↑↑↑↑バリデーション情報↑↑↑↑############

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :plan
  #'acts_as_list'導入に伴う追加記述
  acts_as_list scope: :plan

  #もとのピンが消えた場合、nullとあいて「情報が消されたという情報」は残す。
  belongs_to :drawing_pin, optional: true
  ####↑↑↑↑アソシエーション情報↑↑↑↑############

end
