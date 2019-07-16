module WorkboxesHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）作業箱情報を取得
  def get_workboxes_as_selectbox_info(only_currentuser: true , has_blank: false)
    if only_currentuser
      workboxes = Workbox.where(user_id: current_user.id)
    else
      workboxes = Workbox.all
    end

    if has_blank==true
      box_info = workboxes.map{|workbox| [workbox.workbox_name,workbox.id]}.unshift(["",""])
    else
      box_info = workboxes.map{|workbox| [workbox.workbox_name,workbox.id]}
    end

    #初期選択情報を取得
    if only_currentuser
      default_info = current_user.workboxes.find_by(default_box: true)
      if default_info.blank?
        default_info = ""
      else
        default_info = default_info.id
      end
    else
      default_info = ""
    end

    return [box_info,default_info]

  end

end
