class PlansController < ApplicationController
  include GetPinForPlanShow

  before_action :set_presentation_view_form_type, only: [:presentation]

  def show
    @plan = Plan.find(params[:id])
    #プランが保有しているピン情報
    condition = {plan_id: params[:id]}
    @plan_pins = select_pin_as_plan_member(condition,for_json: true)
    # @plan_pins = select_pin_as_plan_member(params[:id],for_json: true)
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
    condition = {plan_id: params[:id]}
    @plan_pins = select_pin_as_plan_member(condition,for_json: true)

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

  def presentation

  end


  # def make_speech_bubble_plan_candidate
  #   @drawing_pin = DrawingPin.find(params[:pin_id])
  #
  #   respond_to do |format|
  #
  #     format.js { render :make_speech_bubble_plan_candidate(params[:plan_id])}
  #   end
  #
  # end

#   def make_speech_bubble_plan_member
#
# # データ取得部分、まだ未作成
#
#
#     respond_to do |format|
#
#       format.js { render :make_speech_bubble_plan_member(params[:plan_id])}
#     end
#   end

  private
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:user_id, :plan_name, :default_plan, :public_div)
  end


    def set_presentation_view_form_type
      #view_form_type→0：通常画面（サイドバーあり）、1：プレゼン用画面（サイドバーなし）
      @view_form_type = 1
    end

end
