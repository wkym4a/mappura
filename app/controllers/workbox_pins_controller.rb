class WorkboxPinsController < ApplicationController

  def create

    @workbox_pin = WorkboxPin.new(workbox_pin_params)
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    respond_to do |format|
      if @workbox_pin.save
        flash[:notice] = "作業箱「#{@workbox_pin.workbox.workbox_name}」にぴんを登録しました。"
        format.js { render '/drawing_pins/reset_index_and_bubble_item'}
      else
        #エラー情報をフラッシュに保存
        flash[:danger] = @workbox_pin.errors.full_messages
        format.js { render '/drawing_pins/reset_index_and_bubble_item'}
      end
    end

  end

  def destroy

    # 削除時処理
    set_workbox_pin_from_pin_and_box
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    show_workbox_name = @workbox_pin.workbox.workbox_name

    @workbox_pin.destroy

    respond_to do |format|
      flash[:notice]  = "作業箱「#{show_workbox_name}」からぴんを削除しました。"
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}

    end

  end


private
  def set_workbox_pin_from_pin_and_box

    @workbox_pin = WorkboxPin.find_by(workbox_id: params[:workbox_pin][:workbox_id],drawing_pin_id: params[:workbox_pin][:drawing_pin_id])

  end

  def workbox_pin_params
    params.require(:workbox_pin).permit(:workbox_id, :drawing_pin_id)
  end

  def set_drawing_pin(pin_id)
    @drawing_pin = DrawingPin.find(pin_id)
  end

end
