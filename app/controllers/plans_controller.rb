class PlansController < ApplicationController
  include GetPinForPlanShow
  include GetReplacedPinInfo

  before_action :set_presentation_view_form_type, only: [:presentation]

  def show
    set_plan

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

  def edit
    set_plan
  end

  def update
    set_plan

    if not params[:plan][:password] == params[:plan][:password_confirmation]
      flash[:danger] = ["Password confirmationとPasswordの入力が一致しません"]
      redirect_to edit_plan_path(@plan)
    else

      if @plan.update(plan_params_with_pass)
        redirect_to edit_plan_path(@plan.id), notice: '登録に成功しました。'
      else
        #エラー情報をフラッシュに保存して
        flash[:danger] = @plan.errors.full_messages
        redirect_to edit_plan_path(@plan)
      end

    end

  end

  def presentation
    set_plan

    @pins_belongs_to_plan = select_pins_belongs_to_plan(@plan.id,for_json: true)
    @pins_belongs_to_plan_json = @pins_belongs_to_plan.to_json.html_safe

    if @plan.workbox_id.present?
      @pins_belongs_to_workbox = select_pins_belongs_to_workbox_for_plan(@plan.id,@plan.workbox_id,for_json: true)
    else
      @pins_belongs_to_workbox = DrawingPin.none
    end
    # 配列をJsonへ変換する
    @pins_belongs_to_workbox_json = @pins_belongs_to_workbox.to_json.html_safe

  end



  private
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:user_id, :plan_name, :default_plan, :public_div)
  end

  # パスワードが設定されていた場合はパスワードも更新
  def plan_params_with_pass
    if params[:plan][:change_passwordr]=="true"
      params.require(:plan).permit(:plan_name, :public_div, :workbox_id,:password, :password_confirmation)
    else
      params.require(:plan).permit(:plan_name, :public_div, :workbox_id)
    end
  end




  def set_presentation_view_form_type
    #view_form_type→0：通常画面（サイドバーあり）、1：プレゼン用画面（サイドバーなし）
    @view_form_type = 1
  end

end
