class PlanPinsController < ApplicationController
  include GetPinForPlanShow
  include ChkAuthority

  before_action :authenticate_user!
  before_action :authenticate_users_info!

  def new
    #planのshow画面で開く、「まだプランに含まれていない吹き出し」
    #→これからプランに加えるかもしれない、という解釈で、「new」のパスを使用する。
    @drawing_pin = DrawingPin.find(params[:pin_id])
    @plan = Plan.find(params[:plan_id])
  end

  def show
    condition = {plan_pin_id: params[:id]}

    @plan_pin = select_pin_as_plan_member(condition)[0]
    @plan = Plan.find(params[:plan_id])
  end

  def create
    @plan_pin = PlanPin.new(plan_pin_params)
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    # なお、「plan_pinの名前と記事セット」はモデル側（before_validation :set_pin_info）で行う
    set_drawing_pin(@plan_pin.drawing_pin_id)

    respond_to do |format|
      if @plan_pin.save
        flash[:notice] = t('activerecord.normal_process.messages.do_save_this_to',to_this: t('activerecord.models.plan') + "「#{@plan_pin.plan.plan_name}」",this: t('activerecord.models.drawing_pin') )
      else
        #エラー情報をフラッシュに保存
        flash[:danger] = @plan_pin.errors.full_messages
      end
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}
    end
  end

  def create_in_planform

    @plan_pin = PlanPin.new(plan_pin_params)
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    # なお、「plan_pinの名前と記事セット」はモデル側（before_validation :set_pin_info）で行う
    set_drawing_pin(@plan_pin.drawing_pin_id)

    respond_to do |format|
      if @plan_pin.save
        flash[:notice] = t('activerecord.normal_process.messages.do_save_this_to',to_this: t('activerecord.models.plan') + "「#{@plan_pin.plan.plan_name}」",this: t('activerecord.models.drawing_pin') )
      else
        #エラー情報をフラッシュに保存
        flash[:danger] = @plan_pin.errors.full_messages
      end

      format.js { render '/plans/reset_search_and_index'}
    end

  end

  def destroy
    # 削除時処理
    set_plan_pin_from_pin_and_plan
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@plan_pin.drawing_pin_id)

    show_plan_name = @plan_pin.plan.plan_name

    @plan_pin.destroy

    respond_to do |format|
      flash[:notice] = t('activerecord.normal_process.messages.do_del_from',from_this: t('activerecord.models.plan') + "「#{show_plan_name}」",this: t('activerecord.models.drawing_pin') )
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}
    end

  end

  def destroy_in_planform

    # 削除時処理
    @plan_pin = PlanPin.find(params[:id])
    show_plan_name = @plan_pin.plan.plan_name

    @plan_pin.destroy

    respond_to do |format|
      flash[:notice] = t('activerecord.normal_process.messages.do_del_from',from_this: t('activerecord.models.plan') + "「#{show_plan_name}」",this: t('activerecord.models.drawing_pin') )
      format.js { render '/plans/reset_search_and_index'}
    end

  end

  def edit
    set_plan_pin
    @form_name=t('activerecord.models.plan') + ":" + @plan_pin.plan.plan_name
    @form_name_sub="→" + t('activerecord.models.drawing_pin') + t('activerecord.normal_process.noun.update')

    if session["edit_plan_pin"].present?
      #session情報がある場合はそれを取得して、取得したsessionはクリアする（エラー発生によりredirect_toした場合の処理）
      @plan_pin = PlanPin.new(session["edit_plan_pin"])

      session["edit_plan_pin"] = nil
    end

  end

  def update
    set_plan_pin

    if @plan_pin.update(plan_pin_params)
    redirect_to edit_plan_plan_pin_path, notice: t('activerecord.normal_process.messages.do_update')
    else
      #入力情報をセッション、エラー情報をフラッシュに保存して
      session["edit_plan_pin"] = @plan_pin
      flash[:danger] = @plan_pin.errors.full_messages
      redirect_to edit_plan_plan_pin_path
    end

  end



private

  def set_plan_pin
    @plan_pin = PlanPin.find(params[:id])
  end

  def set_plan_pin_from_pin_and_plan
    @plan_pin = PlanPin.find_by(plan_id: params[:plan_pin][:plan_id],drawing_pin_id: params[:plan_pin][:drawing_pin_id])
  end

  def plan_pin_params
    params.require(:plan_pin).permit(:plan_id, :drawing_pin_id,:plan_pin_name,:plan_pin_article,:route)
  end

  def set_drawing_pin(pin_id)
    @drawing_pin = DrawingPin.find(pin_id)
  end

  def authenticate_users_info!
    #プランピンのコントローラーでは、「属しているプランが自身（ログインユーザー）のプランかどうか」で権限チェック
    redirect_to err_path if not is_your_info?(model_name: Plan.name , model_id: params[:plan_id])
  end

end
