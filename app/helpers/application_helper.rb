module ApplicationHelper

  #「自身の値」と「ラジオボックスの値」が一致しているかどうかを見て、そのラジオボックスをチェックすべきかどうか判断する
  def judge_radio_checked(my_value,radio_value)
    if my_value == radio_value
      return  {:checked => true}
    else
      return {}
    end
  end

end
