class PlanPinsController < ApplicationController

  def create

    @plan_pin = PlanPin.new(plan_pin_params)
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@plan_pin.drawing_pin_id)

    @plan_pin.plan_pin_name = @drawing_pin.pin_name
    @plan_pin.plan_pin_article = @drawing_pin.pin_article

    respond_to do |format|
      if @plan_pin.save
        flash[:notice] = "作業箱にぴんを登録しました。"
        format.js { render '/drawing_pins/reset_index_and_bubble_item'}
      else
        #エラー情報をフラッシュに保存
        flash[:danger] = @plan_pin.errors.full_messages
        format.js { render '/drawing_pins/reset_index_and_bubble_item'}
      end
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
