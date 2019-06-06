module PlansHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）プラン情報を取得
  def get_plans_as_selectbox_info(only_currentuser: true , has_blank: false)
    if only_currentuser
      plans = Plan.where(user_id: current_user.id)
    else
      plans = Plan.all
    end

    plans.map{|plan| [plan.plan_name,plan.id]}


    if has_blank==true
      plans.map{|plan| [plan.plan_name,plan.id]}.unshift(["",""])
    else
      plans.map{|plan| [plan.plan_name,plan.id]}
    end
    # if has_blank==true
    #   plans.unshift(["",""])
    # end

  end

end
