module GetPinIndex

  # テスト用? あとで検索条件も加えたものを作る予定
  def select_all_pin(for_json: false)

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

    sql += " order by drawing_pins.created_at "
    # sql = " select * from drawing_pins"
    
    DrawingPin.find_by_sql(sql)

  end


  def select_all_pin_test(for_json: false)

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


        sql += " where id > 18 "#テスト記述

    sql += " order by drawing_pins.created_at "
    # sql = " select * from drawing_pins"

    DrawingPin.find_by_sql(sql)

  end

end
