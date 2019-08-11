class PlansController < ApplicationController
  include GetPinForPlanShow
  include GetReplacedPinInfo
  include ChkAuthority

  before_action :authenticate_user!, if: :not_presentation?
  before_action :authenticate_users_info!, if: :not_presentation?
  before_action :authenticate_presentation!, only: [:presentation]

  before_action :set_presentation_view_form_type, only: [:presentation]


  def show
    set_plan
    @form_name=t('activerecord.models.plan') + t('verb.edit')
    @form_name_sub="(#{@plan.plan_name})"

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
    @plan = Plan.find(params[:id])
    plan_pin = @plan.plan_pins[params[:from].to_i]
    plan_pin.insert_at(params[:to].to_i + 1)
    head :ok
  end

  def edit
    @form_name=t('activerecord.models.plan') + t('noun.contents') + t('activerecord.normal_process.noun.update')
    set_plan

    if session["edit_plan"].present?
      #session情報がある場合はそれを取得して、取得したsessionはクリアする（エラー発生によりredirect_toした場合の処理）
      @plan = Plan.new(session["edit_plan"])

      session["edit_plan"] = nil
    end
  end

  def update
    set_plan

    if not params[:plan][:password] == params[:plan][:password_confirmation]
      #入力情報をセッション、エラー情報をフラッシュに保存して
      session["edit_plan"] = @plan
      flash[:danger] = [t('activerecord.attributes.plan.password') + t('errors.messages.confirmation',attribute: t('activerecord.attributes.plan.password_confirmation'))]
      # ["Password confirmationとPasswordの入力が一致しません"]

      redirect_to edit_plan_path(@plan)
    else

      if @plan.update(plan_params_with_pass)
        redirect_to edit_plan_path(@plan.id), notice: t('activerecord.normal_process.messages.do_save')
      else
        #入力情報をセッション、エラー情報をフラッシュに保存して
        session["edit_plan"] = @plan
        flash[:danger] = @plan.errors.full_messages
        redirect_to edit_plan_path(@plan)
      end

    end

  end


  def reset_pin_route
  # 所属しているピンの経路を一括で変更する
    set_plan

    if @plan.reset_route(params[:plan][:route])
      flash[:notice] = "所属している📍の経路を再設定しました。"
    else
      flash[:danger] = @plan.errors.messages[:route]
    end

    # respond_to do |format|
    #   format.js { render :reset_pin_route }
    # end

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

  def presentation_password
    #プレゼン前の、パスワード確認画面（公開区分が「9:非公開」の場合のみ通る
    set_plan
    @form_name=t('activerecord.attributes.plan.password') + t('verb.confirm')
    @form_name_sub="(#{@plan.plan_name})"
  end

  def presentation_password_chk
    #プレゼン前の、パスワード照合（公開区分が「9:非公開」の場合のみ通る
    set_plan
    if @plan.authenticate(params[:plan][:password]) == false
      #パスワードが違っていた場合
      flash[:danger] = [t('long_msg.plan.password.not_match.msg1'),t('long_msg.plan.password.not_match.msg2')]
      # flash[:danger] = ["パスワードが一致しません。確認して再入力して下さい。","（プラン作成者はプラン更新画面でパスワード再設定可能です）。"]
      redirect_to presentation_password_plan_path(params[:id])
    else
      #入力されたパスワードが合っていた場合
      session["presentation_#{params[:id]}"] = "OK"
      redirect_to presentation_plan_path(params[:id])
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:user_id, :plan_name, :default_plan, :public_div,:image,:remove_image,:comment)
  end

  # パスワードが設定されていた場合はパスワードも更新
  def plan_params_with_pass
    params.require(:plan).permit(:plan_name, :public_div, :workbox_id,:password, :password_confirmation,:image,:remove_image,:comment)
  end

  def set_presentation_view_form_type
    #view_form_type→0：通常画面（サイドバーあり）、1：プレゼン用画面（サイドバーなし）
    @view_form_type = 1
  end

  def not_presentation?
    return (not ["presentation","presentation_password","presentation_password_chk"].include?(action_name))
  end

  def authenticate_users_info!
    redirect_to err_path if not is_your_info?(model_name: Plan.name , model_id: params[:id])
  end

  def authenticate_presentation!
    if session["presentation_#{params[:id]}"].present?
      #session情報がある(=プレゼン用パスワード確認画面を通ってきた)場合は

      #セッション情報を削除して、そのまま表示
      session["presentation_#{params[:id]}"] = nil
    else
      #プランの公開区分が「9：非公開」の場合は、いったん「プレゼン用パスワード確認画面」を通す
      redirect_to presentation_password_plan_path(params[:id]) if set_plan.public_div == 9
    end
  end

end
