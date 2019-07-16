class WorkboxPinsController < ApplicationController
  include ChkAuthority

  before_action :authenticate_user!
  before_action :authenticate_users_info!

  def create

    @workbox_pin = WorkboxPin.new(workbox_pin_params)
    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    respond_to do |format|
      if @workbox_pin.save
        flash[:notice] = t('activerecord.normal_process.messages.do_save_this_to',to_this: t('activerecord.models.workbox') + "「#{@workbox_pin.workbox.workbox_name}」",this: t('activerecord.models.drawing_pin') )

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
    set_workbox_pin

    # 処理後に対象ピンについての表示を再描写するため、ピン情報をインスタンス変数にセット
    set_drawing_pin(@workbox_pin.drawing_pin_id)

    show_workbox_name = @workbox_pin.workbox.workbox_name

    @workbox_pin.destroy

    respond_to do |format|
      flash[:notice] = t('activerecord.normal_process.messages.do_del_from',from_this: t('activerecord.models.workbox') + "「#{show_workbox_name}」",this: t('activerecord.models.drawing_pin') )
      # flash[:notice]  = "作業箱「#{show_workbox_name}」からぴんを削除しました。"
      format.js { render '/drawing_pins/reset_index_and_bubble_item'}
    end
  end

private
  def set_workbox_pin
    @workbox_pin = WorkboxPin.find(params[:id])
  end

  def workbox_pin_params
    params.require(:workbox_pin).permit(:workbox_id, :drawing_pin_id)
  end

  def set_drawing_pin(pin_id)
    @drawing_pin = DrawingPin.find(pin_id)
  end

  def authenticate_users_info!
    #作業箱ピンのコントローラーでは、「属しているプランが自身（ログインユーザー）のプランかどうか」で権限チェック
    redirect_to err_path if not is_your_info?(model_name: Workbox.name , model_id: params[:workbox_id])
  end

end
