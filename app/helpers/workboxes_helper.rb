module WorkboxesHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）作業箱情報を取得
  def get_workboxes_as_selectbox_info(only_currentuser: true , has_blank: false)
    if only_currentuser
      workboxes = Workbox.where(user_id: current_user.id)
    else
      workboxes = Workbox.all
    end

    if has_blank==true
      workboxes.map{|workbox| [workbox.workbox_name,workbox.id]}.unshift(["",""])
    else
      workboxes.map{|workbox| [workbox.workbox_name,workbox.id]}
    end
  end

end
