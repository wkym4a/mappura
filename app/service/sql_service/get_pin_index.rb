module GetPinIndex
  include MakeSql

  def select_pin_index_info(conditions,for_json: false)

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

    sql += " where 1 = 1"

    if not conditions.blank?
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

    sql += " order by drawing_pins.created_at desc "

    DrawingPin.find_by_sql(sql)

  end


end
