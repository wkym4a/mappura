module MakeSql
  extend ActiveSupport::Concern

  #第四引数、search_type……0(初期値):完全一致、1:前方一致、2:後方一致、3:部分一致
  #第五引数、Integer……trueなら数値として検索（search_type＝0、完全一致の場合のみ使用）
  #        Integer=trueは使える機会があれば使う、程度で
  def sql_add_condition( sql , col_name: , condition: , search_type: 0 , search_by_int: false)
    if condition.blank?
      #検索条件なしの場合は、そのまま帰る
      return sql
    else
      #検索条件ありの場合は、その条件をサニタイズしておく
      condition = ActiveRecord::Base.sanitize_sql_for_conditions(condition)
    end

    case search_type
    when 0
      #完全一致
      if search_by_int == true
        return %Q{#{sql} and #{col_name} = #{condition} }
      else
        return %Q{#{sql} and #{col_name} = '#{condition}' }
      end

    when 1
      #前方一致
      return %Q{#{sql} and #{col_name} like '#{condition}%' }

    when 2
      #後方一致
      return %Q{#{sql} and #{col_name} like '%#{condition}' }

    when 3
      #部分一致
      return %Q{#{sql} and #{col_name} like '%#{condition}%' }

    else
      return sql
    end

  end

  #第三引数「」には、画面のチェックボックスの数だけ[対象となる進捗（int型）,チェックされていたかどうか（※）]を格納
  #チャックされていなければnil、されていれば"true（文字列）"
  def sql_add_condition_check( sql , col_name: , condition:)
    #何もチェックされていない場合は、sql文をそのまま返す
    not_chk = true

    sql_sub =  %Q{ and ( 1 = 2 }
    condition.each do |n|
      if not n[1].blank?
        not_chk = false
        sql_sub =  %Q{ #{sql_sub} or #{col_name} = #{n[0]} }
      end
    end
    sql_sub =  %Q{ #{sql_sub} ) }

    if not_chk == true
      return sql
    else
      return sql + sql_sub
    end

  end

  def sql_add_condition_date_fromto( sql , col_name: , condition_from: , condition_to:
    , null_only: false)

    if null_only.blank?
      #「未設定のみ（null_only）」が選択されていないなら、「condition_from」以降、及び「condition_to」以前で検索する

      if not condition_from.blank?
        sql = %Q{#{sql} and TO_CHAR(#{col_name},'YYYY-MM-DD') >= '#{condition_from}' }
      end
      if not condition_to.blank?
        sql = %Q{#{sql} and TO_CHAR(#{col_name},'YYYY-MM-DD') <= '#{condition_to}' }
      end

      return sql

    else
      #日付未設定のみを対象として検索する
      return %Q{#{sql} and #{col_name}  is NULL }
    end

  end

  #####↑sql関係
end
