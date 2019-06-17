module DrawingPinsHelper

  def make_rdb_public_or_not(pin_id: "")

    if pin_id == ""
      #ピン情報がない→新規登録画面の場合
      if user_signed_in?
        if current_user.pin_public_div_default == 0
          return {public_0: {checked: true} ,public_9: {checked: false} }
        else
          return {public_0: {checked: false} ,public_9: {checked: true} }
        end
      else
        #非ログインユーザーの場合→「公開」固定
        #「0:公開」が選択された状態で、「9:非公開」は選択不可
        return {public_0: {checked: true} ,public_9: {disabled: true} }
      end

    else
      #ピン情報がある→更新画面の場合
      if DrawingPin.find(pin_id).public_div==0

        if user_signed_in?
          #ログインユーザーの場合
          #「0:公開」が選択された状態で、「9:非公開」への変更も可能
          return {public_0: {checked: true} ,public_9: {checked: false} }
        else
          #非ログインユーザーの場合→「公開」固定
          #「0:公開」が選択された状態で、「9:非公開」への変更不可
          return {public_0: {checked: true} ,public_9: {disabled: true} }
        end


      else
        #非公開ピンの場合→そのピンのユーザーしか開けないので、ログインしているかどうかの調査は不要
        #「9:非公開」が選択された状態で、「0:公開」への変更も可能
        return {public_0: {checked: false} ,public_9: {checked: true} }
      end
    end

  end

  def can_edit_pin?(pin_info)
    return true if pin_info.user_id.blank?

    if user_signed_in?
      return true if current_user.id ==  pin_info.user_id
    end

    return false

  end

end
