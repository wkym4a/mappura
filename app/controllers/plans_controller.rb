class PlansController < ApplicationController
  include GetPinForPlanShow

  def show
    @plan = Plan.find(params[:id])
    #プランが保有しているピン情報
    @plan_pins = select_pin_as_plan_member(params[:id],for_json: true)
    # 配列をJsonへ変換する
    @plan_pins_json = @plan_pins.to_json.html_safe

    #初期表示時は、「まだプランに追加されていないピン」は検索されないようにする
    @drawing_pins = DrawingPin.none
    # 配列をJsonへ変換する
    @drawing_pins_json = @drawing_pins.to_json.html_safe


  end

  def search_pin_for

    #検索時は「プラン」「プランピン」もデータベースから再取得
    #……「プランピン」の登録，削除後も再検索して表示し直すため。
    @plan = Plan.find(params[:id])
    #プランが保有しているピン情報
    @plan_pins = select_pin_as_plan_member(params[:id],for_json: true)
    # 配列をJsonへ変換する
    @plan_pins_json = @plan_pins.to_json.html_safe

    #まだプランに追加されていないピン（検索
    @drawing_pins = select_pin_as_plan_candidate(params[:conditions],for_json: true)
    # 配列をJsonへ変換する
    @drawing_pins_json = @drawing_pins.to_json.html_safe

    respond_to do |format|

      format.js { render :search_and_index }
    end

  end

  def sort
    # binding.pry
    @plan = Plan.find(params[:id])
    plan_pin = @plan.plan_pins[params[:from].to_i]
    plan_pin.insert_at(params[:to].to_i + 1)
    head :ok
  end

end