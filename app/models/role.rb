class Role < ApplicationRecord


    ####↓↓↓↓アソシエーション情報↓↓↓↓############
    #対象ユーザーが残っている権限は削除不可
    has_many :users , dependent: :restrict_with_error
    ####↑↑↑↑アソシエーション情報↑↑↑↑############
end
