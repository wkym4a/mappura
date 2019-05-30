class DrawingPinsController < ApplicationController
  include GetPinIndex


  def test
    binding.pry
    @drawing_pins = select_all_pin()
      binding.pry
  end

  def index
    @drawing_pins = select_all_pin()

    # 配列をJsonへ変換する
    @drawing_pins_json = select_all_pin(for_json: true)
    @drawing_pins_json = @drawing_pins_json.to_json.html_safe

    # @drawing_pins = DrawingPin.all
  end


  def index_search
    # 仮動作、検索はされない状態
      @drawing_pins = select_all_pin_test()

      # 配列をJsonへ変換する
      @drawing_pins_json = select_all_pin_test(for_json: true)
      @drawing_pins_json = @drawing_pins_json.to_json.html_safe

    respond_to do |format|
        # format.html

        format.js { render :search_result }
    end

  end

  # 「show」画面は作成しない予定……ルートも後で消す
  # def show
  # end

  def new
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

  private

    def set_drawing_pin
      @drawing_pin = DrawingPin.find(params[:id])
    end

    def drawing_pin_params
      params.require(:drawing_pin).permit(:pin_name, :pin_article, :address, :latitude, :longitude, :image, :public_div, :user_id)
    end

end
