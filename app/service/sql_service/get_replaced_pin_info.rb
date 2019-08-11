module GetReplacedPinInfo
  # ワークボックス、プランに所属するピンを「drawing_pins」情報として取得……プレゼンテーション時に使用
  # 「プレゼンテーション時に使用」→削除、非公開設定されている（＋、自身のピンでもない）ピンは表示しない
  include MakeSql

  def select_pins_belongs_to_workbox(workbox_id,for_json: false)

    sql = "select drawing_pins.id "

    if for_json == true
      sql += " ,replace(drawing_pins.pin_name,' ','') as pin_name  "
      sql += " ,replace(drawing_pins.pin_article,' ','') as pin_article  "
      sql += " ,replace(drawing_pins.address,' ','') as address  "
    else
      sql += " ,drawing_pins.pin_name "
      sql += " ,drawing_pins.pin_article "
      sql += " ,drawing_pins.address "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "

    sql += " from workbox_pins"

    sql += " left join drawing_pins"
    sql += " on workbox_pins.drawing_pin_id = drawing_pins.id "

    sql += " left join workboxes"
    sql += " on workbox_pins.workbox_id = workboxes.id "

    sql += " where 1 = 1"
    sql = sql_add_condition(sql , col_name: "workbox_pins.workbox_id" , condition: workbox_id, search_type: 0)

    # 「非公開になっている、プラン作成者自身のピン」のピン情報は取得しない
    #  また「drawing_pins.__」を接続条件に含むことで、削除されているピン情報も取得しない
    #……プレゼン画面ではレコード自体が検索されないものとする
    sql += " and ( "
    sql += " drawing_pins.public_div = 0 "
    sql += " or drawing_pins.user_id = workboxes.user_id "
    sql += " ) "

    sql += " order by drawing_pins.created_at desc "

    DrawingPin.find_by_sql(sql)

  end

  def select_pins_belongs_to_workbox_for_plan(plan_id,workbox_id,for_json: false)
    #プランと一緒に表示するための「ワークボックスに属するピン」→該当するプランに属しているピンは除く。

    sql = "select drawing_pins.id "

    if for_json == true
      sql += " ,replace(drawing_pins.pin_name,' ','') as pin_name  "
      sql += " ,replace(drawing_pins.pin_article,' ','') as pin_article  "
      sql += " ,replace(drawing_pins.address,' ','') as address  "
    else
      sql += " ,drawing_pins.pin_name "
      sql += " ,drawing_pins.pin_article "
      sql += " ,drawing_pins.address "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "

    sql += " from workbox_pins"

    sql += " left join drawing_pins"
    sql += " on workbox_pins.drawing_pin_id = drawing_pins.id "

    sql += " left join workboxes"
    sql += " on workbox_pins.workbox_id = workboxes.id "

    #すでにプランに加えられているピンは、検索対象外とする
    sql += " left join plan_pins"
    sql += " on drawing_pins.id = plan_pins.drawing_pin_id "
    sql = sql_add_condition(sql , col_name: "plan_pins.plan_id" , condition: plan_id , search_type: 0)

    sql += " where 1 = 1"
    sql = sql_add_condition(sql , col_name: "workbox_pins.workbox_id" , condition: workbox_id, search_type: 0)

    # 「非公開になっている、プラン作成者自身のピン」のピン情報は取得しない
    #  また「drawing_pins.__」を接続条件に含むことで、削除されているピン情報も取得しない
    #……プレゼン画面ではレコード自体が検索されないものとする
    sql += " and ( "
    sql += " drawing_pins.public_div = 0 "
    sql += " or drawing_pins.user_id = workboxes.user_id "
    sql += " ) "

    #すでにプランに加えられているピンは、検索対象外とする
    sql += " and plan_pins.plan_id is null "

    ############↓作業箱ピンテーブル、プランピンテーブルに接続しているので、グルーピングでまとめる
    sql += "group by drawing_pins.id "
    if for_json == true
      sql += " ,replace(drawing_pins.pin_name,' ','') "
      sql += " ,replace(drawing_pins.pin_article,' ','') "
      sql += " ,replace(drawing_pins.address,' ','')"
    else
      sql += " ,drawing_pins.pin_name "
      sql += " ,drawing_pins.pin_article "
      sql += " ,drawing_pins.address "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "
    ############↑作業箱ピンテーブル、プランピンテーブルに接続しているので、グルーピングでまとめる

    sql += " order by drawing_pins.created_at desc "

    DrawingPin.find_by_sql(sql)

  end



  def select_pins_belongs_to_plan(plan_id,for_json: false)

    sql = "select drawing_pins.id "

    if for_json == true
      sql += " ,replace(plan_pins.plan_pin_name,' ','') as pin_name  "
      sql += " ,replace(plan_pins.plan_pin_article,' ','') as pin_article  "
      sql += " ,replace(drawing_pins.address,' ','') as address  "
    else
      sql += " ,plan_pins.plan_pin_name  as pin_name  "
      sql += " ,plan_pins.plan_pin_article  as pin_article "
      sql += " ,drawing_pins.address "
    end
    sql += " ,drawing_pins.latitude "
    sql += " ,drawing_pins.longitude "
    sql += " ,drawing_pins.image "
    sql += " ,drawing_pins.public_div "
    sql += " ,plan_pins.position "
    sql += " ,plan_pins.route "

    sql += " from plan_pins"

    sql += " left join drawing_pins"
    sql += " on plan_pins.drawing_pin_id = drawing_pins.id "

    sql += " left join plans"
    sql += " on plan_pins.plan_id = plans.id "

    sql += " where 1 = 1"
    sql = sql_add_condition(sql , col_name: "plan_pins.plan_id" , condition: plan_id, search_type: 0)

    # 「非公開になっている、プラン作成者自身のピン」のピン情報は取得しない
    #  また「drawing_pins.__」を接続条件に含むことで、削除されているピン情報も取得しない
    #……プレゼン画面ではレコード自体が検索されないものとする
    sql += " and ( "
    sql += " drawing_pins.public_div = 0 "
    sql += " or drawing_pins.user_id = plans.user_id "
    sql += " ) "

    sql += " order by plan_pins.position "

    DrawingPin.find_by_sql(sql)

  end



end
