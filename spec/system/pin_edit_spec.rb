require 'rails_helper'

RSpec.describe "Test name", type: :system do


  let!(:user) { FactoryBot.create(:user) }
  let!(:pin_no_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー無しピン名",pin_article: "ユーザー無しピン詳細") }
  let!(:pin_with_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー有りピン名",pin_article: "ユーザー有りピン詳細",user_id: user.id) }

  it "非ログイン者が「ユーザー無しピン」を更新", js: true do
    # 更新画面に移動
    visit edit_drawing_pin_path(pin_no_user.id)

    # 非ログインユーザーの場合、「公開区分=非公開」には設定できない(disable状態である)
    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")
    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_truthy

    # 名称未入力の場合はエラー
    fill_in "drawing_pin_pin_name" ,  with: ""
    find('#btn_save').click
    expect(page).to have_content "を入力してください"

    # save_and_open_page

    # 名称、詳細を変更して、登録
    fill_in "drawing_pin_pin_name" ,  with: "ユーザー無し更新ピン名"
    fill_in "drawing_pin_pin_article" ,  with: "ユーザー無し更新ピン詳細"

    find('#btn_save').click

    expect(page).to have_content "更新に成功しました"

    visit drawing_pins_path
    #一覧画面に移動し、（ログインしていないので検索初期条件なしの状態で）検索
    find('#btn_search').click

    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"
    expect(page).to have_content "ユーザー無し更新ピン名"
    expect(page).to have_content "ユーザー無し更新ピン詳細"

    expect(page).to have_content "ユーザー有りピン名"
    expect(page).to have_content "ユーザー有りピン詳細"

  end

  it "非ログイン者が「ユーザー有りピン」を更新……できない" do
    visit edit_drawing_pin_path(pin_with_user.id)
    #更新画面に移動しようとすると、エラーとなる。
    expect(page).to have_content "実行しようとした処理は権限がないか、データが存在しません"

  end


  it "ログイン者が「ユーザー有りピン」を更新", js: true do

    #まずログイン
    login_as(user)

    # 更新画面に移動
    visit edit_drawing_pin_path(pin_with_user.id)

    # 非ログインユーザーの場合、「公開区分=非公開」に設定できる(disable状態でない)
    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")
    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_falsey

    # 名称未入力の場合はエラー
    fill_in "drawing_pin_pin_name" ,  with: ""
    find('#btn_save').click
    expect(page).to have_content "を入力してください"

    # save_and_open_page

    # 名称、詳細を変更して、登録
    fill_in "drawing_pin_pin_name" ,  with: "ユーザー有り更新ピン名"
    fill_in "drawing_pin_pin_article" ,  with: "ユーザー有り更新ピン詳細"

    find('#btn_save').click

    expect(page).to have_content "更新に成功しました"

    visit drawing_pins_path
    #一覧画面に移動し、（ログインしているので「ログインしているユーザー」の条件で）検索
    find('#btn_search').click

    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"

    expect(page).not_to have_content "ユーザー有りピン名"
    expect(page).not_to have_content "ユーザー有りピン詳細"
    expect(page).to have_content "ユーザー有り更新ピン名"
    expect(page).to have_content "ユーザー有り更新ピン詳細"

  end

  it "ログイン者が「ユーザー無しピン」を更新", js: true do

    #まずログイン
    login_as(user)

    # 更新画面に移動
    visit edit_drawing_pin_path(pin_no_user.id)

    # 非ログインユーザーの場合、「公開区分=非公開」に設定できる(disable状態でない)
    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")
    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_falsey

    # 名称未入力の場合はエラー
    fill_in "drawing_pin_pin_name" ,  with: ""
    find('#btn_save').click
    expect(page).to have_content "を入力してください"

    # save_and_open_page

    # 名称、詳細を変更して、登録
    fill_in "drawing_pin_pin_name" ,  with: "ユーザー無し→有り更新ピン名"
    fill_in "drawing_pin_pin_article" ,  with: "ユーザー無し→有り更新ピン詳細"

    find('#btn_save').click

    expect(page).to have_content "更新に成功しました"

    visit drawing_pins_path
    #一覧画面に移動し、（ログインしていないので検索初期条件なしの状態で）検索
    find('#btn_search').click

    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"
    expect(page).to have_content "ユーザー無し→有り更新ピン名"
    expect(page).to have_content "ユーザー無し→有り更新ピン詳細"

    expect(page).to have_content "ユーザー有りピン名"
    expect(page).to have_content "ユーザー有りピン詳細"

  end

  it "ログイン者が「ユーザー無しピン」を「非公開」に更新", js: true do

    #まずログイン
    login_as(user)

    # 更新画面に移動
    visit edit_drawing_pin_path(pin_with_user.id)

    # 非ログインユーザーの場合、「公開区分=非公開」に設定できる(disable状態でない)
    checkbox_0 = find("#drawing_pin_public_div_0")
    checkbox_9 = find("#drawing_pin_public_div_9")
    expect(checkbox_0.disabled?).to be_falsey
    expect(checkbox_9.disabled?).to be_falsey

    #「非公開」で登録する
    choose "drawing_pin_public_div_9"
    find('#btn_save').click

    expect(page).to have_content "更新に成功しました"

    #ログアウトして、「非ログインユーザー」で一覧画面へ
    logout
    visit drawing_pins_path
    #一覧画面に移動し、（ログインしていないので検索初期条件なしの状態で）検索
    find('#btn_search').click

    expect(page).to have_content "ユーザー無しピン名"
    expect(page).to have_content "ユーザー無しピン詳細"
    #「非公開」になった「ユーザー有りピン」は検索されなくなる
    expect(page).not_to have_content "ユーザー有りピン名"
    expect(page).not_to have_content "ユーザー有りピン詳細"

  end


  it "ピン削除", js: true do
    FactoryBot.create(:drawing_pin,pin_name: "最後に一本残ったピン")

    #まずログイン
    login_as(user)

    # 更新画面に移動して削除
    visit edit_drawing_pin_path(pin_with_user.id)
    find('#btn_delete').click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content "📍を削除しました"

    #ログアウトして、「非ログインユーザー」で一覧画面へ
    logout
    # 更新画面に移動して削除
    visit edit_drawing_pin_path(pin_no_user.id)
    find('#btn_delete').click
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content "📍を削除しました"

    visit drawing_pins_path
    #一覧画面に移動し、（ログインしていないので検索初期条件なしの状態で）検索
    find('#btn_search').click

    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"
    #「非公開」になった「ユーザー有りピン」は検索されなくなる
    expect(page).not_to have_content "ユーザー有りピン名"
    expect(page).not_to have_content "ユーザー有りピン詳細"

    expect(page).to have_content "最後に一本残ったピン"

  end

end
