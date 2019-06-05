class WorkboxPinsController < ApplicationController

  def create_or_destroy_from_index

    if set_workbox_pin_from_pin_and_box.blank?
    #取得した作業箱とピンの情報で「workbox_pin」テーブルを検索。
    #検索結果がなければ作成、あれば削除処理を行う
    #……地図上の吹き出しでは「params[:commit]」やurl指定での「作成/削除」判別が効かないため、
    #この方法をとっている。
    # if params[:commit] == "に追加"

      # 登録時処理
      #   binding.pry
      @workbox_pin = WorkboxPin.new(workbox_pin_params)
      set_drawing_pin(@workbox_pin.drawing_pin_id)

      respond_to do |format|
        if @workbox_pin.save
          flash[:notice] = "作業箱にぴんを登録しました。"
          format.js { render '/drawing_pins/reset_index_and_bubble_item'}
        else
          #エラー情報をフラッシュに保存
          flash[:danger] = @workbox_pin.errors.full_messages
          format.js { render '/drawing_pins/reset_index_and_bubble_item'}
        end
      end

    else
      # 削除時処理
      set_workbox_pin_from_pin_and_box
      set_drawing_pin(@workbox_pin.drawing_pin_id)

      @workbox_pin.destroy

      respond_to do |format|
        flash[:notice]  = "作業箱からぴんを削除しました。"
        format.js { render '/drawing_pins/reset_index_and_bubble_item'}

      end

    end

  end

  def create

    @workbox_pin = WorkboxPin.new(workbox_pin_params)
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    respond_to do |format|
      if @workbox_pin.save
        flash[:notice] = "作業箱にぴんを登録しました。"
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
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    @workbox_pin.destroy

    respond_to do |format|
      flash[:notice]  = "作業箱からぴんを削除しました。"
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
