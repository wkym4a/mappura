module GetPinForPlanShow
  include MakeSql

  def select_pin_as_plan_candidate(conditions,for_json: false)
    #プランに追加する候補としてぴんを検索する
    #→すでにぴんに追加されているプランは対象外
    sql = "select drawing_pins.id "

    if for_json == true
      sql += " ,replace(drawing_pins.pin_name,' ','') as pin_name  "
      sql += " ,replace(drawing_pins.pin_article,' ','') as pin_article  "
    else
      sql += " ,drawing_pins.pin_name "
      sql += " ,drawing_pins.pin_article "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "

    sql += " from drawing_pins"

    sql += " left join users"
    sql += " on drawing_pins.user_id = users.id "

    #すでにプランに加えられているピンは、検索対象外とする
    sql += " left join plan_pins"
    sql += " on drawing_pins.id = plan_pins.drawing_pin_id "
    if not conditions.blank?
      # sql += " and not (1 = 1 "
      sql = sql_add_condition(sql , col_name: "plan_pins.plan_id" , condition: conditions[:plan_id] , search_type: 0)
      # sql += " ) "
    end

    sql += " left join workbox_pins"
    sql += " on drawing_pins.id = workbox_pins.drawing_pin_id "

    sql += " where 1 = 1 "
    sql += " and plan_pins.plan_id is null "

    if not conditions.blank?

      #作業箱（セレクトボックスで選択された情報→完全一致）
      sql = sql_add_condition(sql , col_name: "workbox_pins.id" , condition: conditions[:workbox_id] , search_type: 0)

      #ユーザーネーム（一意情報→完全一致）
      sql = sql_add_condition(sql , col_name: "users.user_name" , condition: conditions[:user_name] , search_type: 0)

      #登録日
      sql = sql_add_condition_date_fromto(sql , col_name: "drawing_pins.created_at" ,
         condition_from: conditions[:created_at_from] , condition_to: conditions[:created_at_to])

       #名称（部分一致）
      sql = sql_add_condition(sql , col_name: "drawing_pins.pin_name" , condition: conditions[:pin_name] , search_type: 3)

       #更新日
       sql = sql_add_condition_date_fromto(sql , col_name: "drawing_pins.updated_at" ,
          condition_from: conditions[:updated_at_from] , condition_to: conditions[:updated_at_to])

        #詳細（部分一致）
       sql = sql_add_condition(sql , col_name: "drawing_pins.pin_article" , condition: conditions[:pin_article] , search_type: 3)

       #住所（部分一致）
      sql = sql_add_condition(sql , col_name: "drawing_pins.address" , condition: conditions[:address] , search_type: 3)
    end

    sql += " and ( "
    sql += " drawing_pins.public_div = 0 "
    if user_signed_in?
      sql += " or drawing_pins.user_id = #{current_user.id}"
    end
    sql += " ) "

    ############↓作業箱ピンテーブル、プランピンテーブルに接続しているので、グルーピングでまとめる
    sql += "group by drawing_pins.id "
    if for_json == true
      sql += " ,replace(drawing_pins.pin_name,' ','') "
      sql += " ,replace(drawing_pins.pin_article,' ','') "
    else
      sql += " ,drawing_pins.pin_name "
      sql += " ,drawing_pins.pin_article "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "
    ############↑作業箱ピンテーブル、プランピンテーブルに接続しているので、グルーピングでまとめる

    sql += " order by drawing_pins.created_at desc "

    DrawingPin.find_by_sql(sql)

  end

  def select_pin_as_plan_member(plan_id,for_json: false)
    #すでにプランに追加されているぴんを検索する
    #→引数として獲得したピンで検索、検索条件は必要ない
    #
    sql = "select plan_pins.id "
    sql += " ,plan_pins.plan_id "
    sql += " ,plan_pins.drawing_pin_id "
    sql += " ,plan_pins.position "

    if for_json == true
      sql += " ,replace(plan_pins.plan_pin_name,' ','') as pin_name  "
      sql += " ,replace(plan_pins.plan_pin_article,' ','') as pin_article  "
    else
      sql += " ,plan_pins.plan_pin_name as pin_name "
      sql += " ,plan_pins.plan_pin_article as pin_article "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "

    sql += " from plan_pins"

    sql += " left join drawing_pins"
    sql += " on plan_pins.drawing_pin_id = drawing_pins.id "

    sql += " left join plans"
    sql += " on plan_pins.plan_id = plans.id "

    sql += " where 1 = 1"

    sql = sql_add_condition(sql , col_name: "plan_pins.plan_id" , condition: plan_id , search_type: 0)


    sql += " and ( "
    sql += " drawing_pins.public_div = 0 "
    sql += " or drawing_pins.user_id = plans.user_id "
    sql += " ) "

    sql += " order by plan_pins.position"

    PlanPin.find_by_sql(sql)

  end

end
