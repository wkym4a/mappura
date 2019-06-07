class PlanPinsController < ApplicationController
  include GetPinForPlanShow

  def new
    #planのshow画面で開く、「まだプランに含まれていない吹き出し」
    #→これからプランに加えるかもしれない、という解釈で、「new」のパスを使用する。
    @drawing_pin = DrawingPin.find(params[:pin_id])
    @plan = Plan.find(params[:plan_id])
  end

  def show


    condition = {plan_pin_id: params[:plan_pin_id]}

    @plan_pin = select_pin_as_plan_member(condition)[0]
    @plan = Plan.find(params[:plan_id])

  end

  def create

    @plan_pin = PlanPin.new(plan_pin_params)
    # plan_pinの名前と記事セット＋処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@plan_pin.drawing_pin_id)

    @plan_pin.plan_pin_name = @drawing_pin.pin_name
    @plan_pin.plan_pin_article = @drawing_pin.pin_article

    respond_to do |format|
      if @plan_pin.save
        flash[:notice] = "作業箱にぴんを登録しました。"
      else
        #エラー情報をフラッシュに保存
        flash[:danger] = @plan_pin.errors.full_messages
      end
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}
    end
  end


  def create_in_planform

    @plan_pin = PlanPin.new(plan_pin_params)
    # plan_pinの名前と記事セットのため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@plan_pin.drawing_pin_id)

    @plan_pin.plan_pin_name = @drawing_pin.pin_name
    @plan_pin.plan_pin_article = @drawing_pin.pin_article

    respond_to do |format|
      if @plan_pin.save
        flash[:notice] = "作業箱にぴんを登録しました。"
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

    @plan_pin.destroy

    respond_to do |format|
      flash[:notice]  = "作業箱からぴんを削除しました。"
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}

    end

  end

  def destroy_in_planform

    # 削除時処理
    @plan_pin = PlanPin.find(params[:plan_pin][:plan_pin_id])

    @plan_pin.destroy

    respond_to do |format|
      flash[:notice]  = "作業箱からぴんを削除しました。"
      format.js { render '/plans/reset_search_and_index'}

    end

  end

private
  def set_plan_pin_from_pin_and_plan

    @plan_pin = PlanPin.find_by(plan_id: params[:plan_pin][:plan_id],drawing_pin_id: params[:plan_pin][:drawing_pin_id])

  end

  def plan_pin_params
    params.require(:plan_pin).permit(:plan_id, :drawing_pin_id)
  end

  def set_drawing_pin(pin_id)
    @drawing_pin = DrawingPin.find(pin_id)
  end

end
