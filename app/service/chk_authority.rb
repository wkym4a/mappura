module ChkAuthority
  # include MakeSql



  def is_your_info?(model_name: , model_id: )
    #第一引数：モデル名、第二引数：そのモデル（＝テーブル）情報のid
    # => 戻り値：【その情報が持つユーザー情報が『ログインユーザー』と一致する（true）かしない（false）か】

    case model_name
      #モデル名に応じて、『そのidレコードのユーザー情報』を取得
      # => 現在ログインしているユーザーと同じであればTを返す
    when User.name
      return true if current_user.id == model_id.to_i

    when DrawingPin.name
      return true if current_user.id == DrawingPin.find(model_id).user_id

    when Workbox.name
      return true if current_user.id == Workbox.find(model_id).user_id

    when WorkboxPin.name
      return true if current_user.id == WorkboxPin.find(model_id).workbox.user_id

    when Plan.name
      return true if current_user.id == Plan.find(model_id).user_id

    when PlanPin.name
      return true if current_user.id == PlanPin.find(model_id).plan.user_id

    end

    #一致しなかった、あるいは該当するモデル名がなかった場合はFを返す
    return false

  end

end
