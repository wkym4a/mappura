class WorkboxPin < ApplicationRecord

  ########↓バリデーション情報↓########
  validates :workbox_id,  uniqueness: { scope: :drawing_pin_id}
  ########↑バリデーション情報↑########

  ####↓↓↓↓アソシエーション情報↓↓↓↓############
  belongs_to :workbox

  #もとのピンが消えた場合、nullと変えて「情報が消されたという情報」は残す。
  belongs_to :drawing_pin, optional: true
  ####↑↑↑↑アソシエーション情報↑↑↑↑############
end
