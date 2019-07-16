require 'rails_helper'

RSpec.describe "Test name", type: :system do

  it "「座標→住所」ボタン、異常系", js: true do

    visit new_drawing_pin_path

    find('#btn_set_address_by_latlng').click
    expect(page).to have_content "緯度、経度を入力してください"

    fill_in "drawing_pin_latitude" ,  with: "aaaa"
    fill_in "drawing_pin_longitude" ,  with: "bbbb"
    find('#btn_set_address_by_latlng').click
    expect(page).to have_content "緯度、経度には数値を入力してください。"

    fill_in "drawing_pin_latitude" ,  with: "0"
    fill_in "drawing_pin_longitude" ,  with: "181"
    find('#btn_set_address_by_latlng').click
    expect(page).to have_content "緯度は「-90」〜「90」、経度は「-180」〜「180」の範囲で入力してください"

    fill_in "drawing_pin_latitude" ,  with: "-91"
    fill_in "drawing_pin_longitude" ,  with: "0"
    find('#btn_set_address_by_latlng').click
    expect(page).to have_content "緯度は「-90」〜「90」、経度は「-180」〜「180」の範囲で入力してください"

  end

  it "「座標→住所」ボタン、正常系(ただし住所取得失敗)_ついでに「名称必須」も確認", js: true do

    visit new_drawing_pin_path

    fill_in "drawing_pin_latitude" ,  with: "0"
    fill_in "drawing_pin_longitude" ,  with: "0"
    find('#btn_set_address_by_latlng').click

    expect(page).to have_content "座標から住所を獲得できませんでした。住所は手入力で入力してください。"

    #登録ボタンを押せる（＝名称未入力の現状では押すことでエラーが発生する）ことを確認
    find('#btn_save').click
    expect(page).to have_content "を入力してください"

  end
  it "「座標→住所」ボタン、正常系(住所取得にも成功)_ついでに「名称必須」も確認", js: true do

    visit new_drawing_pin_path

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    expect(page).not_to have_content "座標から住所を獲得できませんでした。住所は手入力で入力してください。"

    #登録ボタンを押せる（＝名称未入力の現状では押すことでエラーが発生する）ことを確認
    find('#btn_save').click
    expect(page).to have_content "を入力してください"

  end


  it "「座標→住所」ボタン、異常系", js: true do

    visit new_drawing_pin_path

    find('#btn_set_latlng_by_address').click
    expect(page).to have_content "住所を入力してください。"

    fill_in "drawing_pin_address" ,  with: "不正な住所情報を入力"
    find('#btn_set_latlng_by_address').click
    expect(page).to have_content "住所から座標を獲得できませんでした。"

  end

    it "「座標→住所」ボタン、正常系", js: true do

      visit new_drawing_pin_path

      find('#btn_set_latlng_by_address').click
      expect(page).to have_content "住所を入力してください。"

      fill_in "drawing_pin_address" ,  with: "東京都渋谷区円山町28番4号大場ビルA館4階ab"
      find('#btn_set_latlng_by_address').click
      expect(page).not_to have_content "住所から座標を獲得できませんでした。"

      #登録ボタンを押せる（＝名称未入力の現状では押すことでエラーが発生する）ことを確認
      find('#btn_save').click
      expect(page).to have_content "を入力してください"

    end

# 文字数オーバーの試験は不要
# ……html側で「入力可能な最大桁数」を「名前→30字、詳細→180字、住所→255字」と制限した。
# 緯度経度は大きすぎても登録時に勝手に丸めてくれる。

  it "非ログインユーザーの場合、「公開区分=非公開」には設定できない(disable状態である)", js: true do

    visit new_drawing_pin_path

    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")

    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_truthy
    # choose "drawing_pin_public_div_0"
  end

  it "ログインユーザーの場合、「公開区分=非公開」に設定できる", js: true do
    #先にログインしておく
    user = FactoryBot.create(:user)
    login_as(user)

    visit new_drawing_pin_path

    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")
    #ログインしていれば「非公開」も「disable」ではない
    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_falsey

    #初期状態では「公開」が選択されているが
    expect(checkbox_0).to be_checked
    expect(checkbox_9).not_to be_checked

    #「非公開」にすることもできる
    choose "drawing_pin_public_div_9"
    expect(checkbox_0).not_to be_checked
    expect(checkbox_9).to be_checked

  end

  it "登録テスト1" , js: true do

    ####非ログインユーザーで登録
    visit new_drawing_pin_path
    fill_in "drawing_pin_pin_name" ,  with: "名称その一"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    ####ユーザーでログインする
    user = FactoryBot.create(:user)
    login_as(user)

    visit new_drawing_pin_path
    ####ログインユーザーで登録（公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その二"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"


    ####ログインユーザーで登録（非公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その三"
    #「非公開」で登録する
    choose "drawing_pin_public_div_9"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    visit drawing_pins_path
    #一覧画面に移動し、（検索初期条件で自身のユーザーネームがセットされている状態で）検索
    find('#btn_search').click

    # => 非ログインユーザーのピンは検索されない
    expect(page).not_to have_content "名称その一"
    expect(page).to have_content "名称その二"
    expect(page).to have_content "名称その三"

  end

  it "登録テスト2", now: true , js: true do

    ####非ログインユーザーで登録
    visit new_drawing_pin_path
    fill_in "drawing_pin_pin_name" ,  with: "名称その一"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    ####ユーザーでログインする
    user = FactoryBot.create(:user)
    login_as(user)

    visit new_drawing_pin_path
    ####ログインユーザーで登録（公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その二"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    ####ログインユーザーで登録（非公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その三"
    #「非公開」で登録する
    choose "drawing_pin_public_div_9"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    visit drawing_pins_path
    find('#conditions_user_name').set("")
    #fill_in "conditions_user_name" ,  with: ""
    #検索初期条件のユーザーネームを消してから検索
    find('#btn_search').click
    #
    # fill_in "conditions_user_name" ,  with: "っっっｔ"
    # #検索初期条件のユーザーネームを消してから検索
    # find('#btn_search').click

    fill_in "conditions_user_name" ,  with: ""
    #検索初期条件のユーザーネームを消してから検索
    find('#btn_search').click

    # => ログインユーザーのピンも検索される
    expect(page).to have_content "名称その一"
    expect(page).to have_content "名称その二"
    expect(page).to have_content "名称その三"

  end

  it "登録テスト3" , js: true do

    ####非ログインユーザーで登録
    visit new_drawing_pin_path
    fill_in "drawing_pin_pin_name" ,  with: "名称その一"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    ####ユーザーでログインする
    user = FactoryBot.create(:user)
    login_as(user)

    visit new_drawing_pin_path
    ####ログインユーザーで登録（公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その二"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    ####ログインユーザーで登録（非公開）
    fill_in "drawing_pin_pin_name" ,  with: "名称その三"
    #「非公開」で登録する
    choose "drawing_pin_public_div_9"

    fill_in "drawing_pin_latitude" ,  with: "10"
    fill_in "drawing_pin_longitude" ,  with: "10"
    find('#btn_set_address_by_latlng').click

    find('#btn_save').click
    expect(page).to have_content "登録に成功しました。次のピンを登録してください。登録を終える場合は左側のボタンから戻ってください"

    logout
    visit drawing_pins_path
    #ログアウトしてから一覧画面に移動し、（ログインしていないので検索初期条件なしの状態で）検索
    find('#btn_search').click

    # => 非公開である「名称その三」は表示されない
    expect(page).to have_content "名称その一"
    expect(page).to have_content "名称その二"
    expect(page).not_to have_content "名称その三"

  end
  
end
