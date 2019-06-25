class DrawingPinsController < ApplicationController
  include GetPinIndex
  include ChkAuthority

  # before_action :authenticate_user!
  before_action :authenticate_users_info! ,only: [:edit,:update,:destroy]

  def index
    @form_name="📍一覧"

    if user_signed_in?
      condition = {user_name: current_user.user_name}
    else
      condition = {}
    end

    #初期表示時は、「まだプランに追加されていないピン」は検索されないようにする
    @drawing_pins = DrawingPin.none
    # @drawing_pins = select_pin_index_info(condition,for_json: true)

    # 配列をJsonへ変換する
    @drawing_pins_json = @drawing_pins.to_json.html_safe

  end


  def index_search

    @drawing_pins = select_pin_index_info(params[:conditions],for_json: true)
    # 配列をJsonへ変換する
    @drawing_pins_json = @drawing_pins.to_json.html_safe

    respond_to do |format|
        # format.html

        format.js { render :search_result }
    end

  end

  #「作業箱」または「プラン」に、対象のピンを「削除する」のか「追加する」のか
  # （＝そのピンが現在登録されて「いる」のか「いない」のか）を判断する
  def judge_add_or_remove

    case params[:type]
    when "workbox"

      get_data= WorkboxPin.where("(workbox_id = ?) and (drawing_pin_id = ?)", params[:selected_id],params[:pin_id])

    when "plan"
      get_data= PlanPin.where("(plan_id = ?) and (drawing_pin_id = ?)", params[:selected_id],params[:pin_id])

    else
      #ここは通らないはずだが、念の為
      get_data= []

    end
    render json: get_data
  end

  def make_speech_bubble
    set_drawing_pin

    respond_to do |format|
        # format.html

      format.js { render :make_speech_bubble }
    end

  end

  def new
    @form_name="ピン作成"
    @drawing_pin = DrawingPin.new

    if session["new_drawing_pin"].present?
      #session情報がある場合はそれを取得して、取得したsessionはクリアする（エラー発生によりredirect_toした場合の処理）
      @drawing_pin = DrawingPin.new(session["new_drawing_pin"])

      session["new_drawing_pin"] = nil

    end

  end

  def create
    @drawing_pin = DrawingPin.new(drawing_pin_params)

    #ログインしている場合はユーザーidをセット……ログインしていない場合は「ユーザーid=null」で登録可能にする。
    if user_signed_in?
      @drawing_pin.user_id = current_user.id
    end

    if @drawing_pin.save
      redirect_to new_drawing_pin_path, notice: '登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください。'
    else
      #入力情報をセッション、エラー情報をフラッシュに保存して
      session["new_drawing_pin"] = @drawing_pin
      flash[:danger] = @drawing_pin.errors.full_messages
      redirect_to new_drawing_pin_path
    end

  end


    def edit
      @form_name="ピン更新"
      set_drawing_pin

    end

    def update
      set_drawing_pin

      #「ログインユーザー」が「ユーザー未設定のピン」を更新した場合、そのピンは更新した「ログインユーザー」のものとなる
      if signed_in? && @drawing_pin.user_id.nil?
        params[:drawing_pin][:user_id]=current_user.id
      end

      if @drawing_pin.update(drawing_pin_params)
        redirect_to edit_drawing_pin_path, notice: '更新に成功しました。'
      else
        #エラー情報をフラッシュに保存してrender
        flash[:danger] = @drawing_pin.errors.full_messages
        render "edit"

      end
    end


    def destroy
      set_drawing_pin
      @drawing_pin.destroy

      redirect_to drawing_pins_path, notice: 'ピンを削除しました。'

    end

  private

    def set_drawing_pin
      @drawing_pin = DrawingPin.find(params[:id])
    end

    def drawing_pin_params
      params.require(:drawing_pin).permit(:pin_name, :pin_article, :address, :latitude, :longitude, :image, :public_div, :user_id)
    end


    def authenticate_users_info!

      #ピンに「登録ユーザー情報」が存在すれば
      #……存在しない場合は、誰でも更新，削除可能
      if set_drawing_pin.user_id.present?

        #「登録ユーザー情報」が存在するピンの場合、
        if not user_signed_in?
        #ログインしていなければエラー
          redirect_to err_path
        else
         #ログインしていても、ピンを登録したユーザーでなければエラー
         redirect_to err_path if not is_your_info?(model_name: DrawingPin.name , model_id: params[:id])
        end

      end
    end

end
