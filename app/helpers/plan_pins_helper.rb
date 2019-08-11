module PlanPinsHelper

  #セレクトボックス作成のために、（引数がTならば現在ユーザーの）プラン情報を取得
  def get_routes_as_selectbox_info(has_blank: false)
  # def get_routes_as_selectbox_info(planpin_id: "", has_blank: false)

    # plan_pins = Plan.find(plan_id).order(:created_at)
    #
    # if only_currentuser
    #   plans = Plan.find(plan_id).order(:created_at)
    # else
    #   plans = Plan.all.order(:created_at)
    # end

    if has_blank==true
      box_info = (0..3).map{|route_type| [get_route_name(route_type),route_type]}.unshift(["",""])
    else
      box_info = (0..3).map{|route_type| [get_route_name(route_type),route_type]}
    end

    return box_info
        # return [box_info,planpin_id]

  end

  def get_route_name(route_type)

    case route_type

    when 0
      return "非表示"

    when 1
      return "直線"

    when 2
      return  "道程"

    when 3
      return  "道程(車：不使用)"

    else
      return "想定外の種類"
    end
  end

end
