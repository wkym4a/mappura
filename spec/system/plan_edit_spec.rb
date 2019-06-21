require 'rails_helper'

RSpec.describe "Test name", type: :system do

  let(:user) { FactoryBot.create(:user) }
  let(:plan) { FactoryBot.create(:plan,user_id: user.id,plan_name: "プランの名称") }

  it "非ログイン者が「プラン」を更新……できない", js: true do
    visit edit_plan_path(plan.id)
    #更新画面に移動しようとすると、エラーとなる。
    expect(page).to have_content "アカウント登録もしくはログインしてください"

  end

  it "ログイン者が「プラン」を更新", js: true do
    #まずログイン
    login_as(user)

    visit  edit_plan_path(plan.id)

    # 名称未入力の場合はエラー
    fill_in "plan_plan_name" ,  with: ""
    find('#btn_save').click
    expect(page).to have_content "を入力してください"


    # 名称未入力の場合はエラー
    fill_in "plan_plan_name" ,  with: "プラン更新"
    find('#btn_save').click
    expect(page).to have_content "登録に成功しました"

    #念のため表示しなおしても
    visit  edit_plan_path(plan.id)
    # プランが更新されている
    expect(page).not_to have_content "プランの名称"
    expect(page).to have_content "プラン更新"

  end

  it "「プラン」を「非公開」に変更", js: true do
    #まずログイン
    login_as(user)

    visit edit_plan_path(plan.id)

    #「非公開」で登録する
    choose "plan_public_div_9"
    find('#btn_save').click
    # 非公開の場合はパスワード必須
    expect(page).to have_content "「非公開」にする場合はパスワードを設定してください"

    fill_in "plan_password" ,  with: "password_settei"
    fill_in "plan_password_confirmation" ,  with: "password_settei"
    find('#btn_save').click
    expect(page).to have_content "登録に成功しました"

    visit presentation_plan_path(plan.id)
    expect(page).to have_content "非公開プランです。パスワードを入力してください"

    fill_in "password" ,  with: "aaaaaaaa"
    find('#btn_confirm').click
    expect(page).to have_content "パスワードが一致しません。確認して再入力して下さい"

    fill_in "password" ,  with: "password_settei"
    find('#btn_confirm').click
    expect(page).to have_content "【#{plan.plan_name}】"

    visit edit_plan_path(plan.id)
    #再びプラン更新画面に戻り、公開区分を「公開」にすると
    choose "plan_public_div_0"
    find('#btn_save').click
    # 公開プランなので、パスワードなしでプレゼンテーション画面に移動する
    visit presentation_plan_path(plan.id)
    expect(page).to have_content "【#{plan.plan_name}】"

  end

end
