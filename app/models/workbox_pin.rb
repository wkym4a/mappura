class WorkboxPin < ApplicationRecord
  belongs_to :workbox

  #もとのピンが消えた場合、nullとあいて「情報が消されたという情報」は残す。
  belongs_to :drawing_pin, optional: true
end
