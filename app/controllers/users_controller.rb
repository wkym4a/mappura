class UsersController < ApplicationController

  include ChkAuthority

  before_action :authenticate_user! ,only: [:edit, :update]
  before_action :authenticate_users_info! ,only: [:edit, :update]
  before_action :authenticate_see_profile! ,only: [:show]

  before_action :set_user, only: [:show, :edit, :update]
  def show
  end

  def edit
  end

  def update
    if @user.update(user_params_for_update)
      redirect_to @user, notice: 'ユーザー情報を変更しました。'
    else
      #エラー情報をフラッシュに保存
      flash[:danger] = @user.errors.full_messages
      render :edit
    end
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params_for_update
    params_info = params.require(:user).permit(:account_name, :email_public_div, :profile, :public_div, :pin_public_div_default,
        workboxes_attributes: [:id, :workbox_name, :default_box, :_destroy],
        plans_attributes: [:id, :plan_name, :default_plan, :_destroy])

    #「ラジオボックスがoffだった場合」はフォームからは何の値も取得されないので、
    #その場合はここで「標準ではない(=false)」旨を設定する。
    if params_info[:workboxes_attributes].present?
      params_info[:workboxes_attributes].each do |workbox|
        if not (workbox[1][:default_box] == "true")
          workbox[1][:default_box] = "false"
        end
      end
    end

    #「ラジオボックスがoffだった場合」はフォームからは何の値も取得されないので、
    #その場合はここで「標準ではない(=false)」旨を設定する。
    if params_info[:plans_attributes].present?
      params_info[:plans_attributes].each do |plan|
        if not (plan[1][:default_plan] == "true")
          plan[1][:default_plan] = "false"
        end
      end
    end

    return  params_info
  end


  def authenticate_users_info!
    redirect_to err_path if not is_your_info?(model_name: User.name , model_id: params[:id])
  end

  def authenticate_see_profile!
    #プロフィールは「公開」されていれば誰にでも閲覧可能
    #非公開（＝9）の場合のみ、自分（ログイン者）のユーザー情報かチェック
    authenticate_users_info! if set_user.public_div == 9
  end

end
