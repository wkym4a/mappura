module PlansHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）プラン情報を取得
  def get_plans_as_selectbox_info(only_currentuser: true)
    if only_currentuser
      plans = Plan.where(user_id: current_user.id)
    else
      plans = Plan.all
    end

    plans.map{|plan| [plan.plan_name,plan.id]}

  end

end
