module PlansHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）プラン情報を取得
  def get_plans_as_selectbox_info(only_currentuser: true , has_blank: false)
    if only_currentuser
      plans = Plan.where(user_id: current_user.id)
    else
      plans = Plan.all
    end

    if has_blank==true
      box_info = plans.map{|plan| [plan.plan_name,plan.id]}.unshift(["",""])
    else
      box_info = plans.map{|plan| [plan.plan_name,plan.id]}
    end

    #初期選択情報を取得
    if only_currentuser
      default_info = current_user.plans.find_by(default_plan: true)
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
