require 'rails_helper'

RSpec.describe "Test name", type: :system do


  let!(:user) { FactoryBot.create(:user) }
  let!(:pin_no_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー無しピン名",pin_article: "ユーザー無しピン詳細") }
  let!(:pin_with_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー有りピン名",pin_article: "ユーザー有りピン詳細",user_id: user.id) }

  let!(:user2) { FactoryBot.create(:user,user_name: "2の人" ,email: "betu@test.co.jp") }
  let!(:plan2) { FactoryBot.create(:plan, plan_name: "プラン2名",user_id: user2.id) }

  let!(:pin_use2) { FactoryBot.create(:drawing_pin,pin_name: "2の人のピン名",pin_article: "2の人のピン詳細",user_id: user.id) }

  let!(:plan2_pin_no_user) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_no_user.id) }
  let!(:plan2_pin_with_user) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_with_user.id) }
  let!(:plan2_pin_with_user2) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_use2.id) }


  it "そのプランを作成したユーザーでないと、入れない" do
    #プラン表示画面へ、ログインせずに入ろうとする
    visit edit_plan_plan_pin_path(plan2.id,plan2_pin_no_user.id)
    expect(page).to have_content "アカウント登録もしくはログインしてください。"

    #プラン表示画面へ、別のユーザーで入ろうとする
    login_as(user)
    #プラン表示画面へ、ログインせずに入ろうとする
    visit edit_plan_plan_pin_path(plan2.id,plan2_pin_no_user.id)
    expect(page).to have_content "実行しようとした処理は権限がないか、データが存在しません。"

  end

  it "ピン更新（ユーザー無しピン）", js: true do

    #まずログイン
    login_as(user2)
    visit edit_plan_plan_pin_path(plan2.id,plan2_pin_no_user.id)
    # expect(page).to have_content "ユーザー無しピン名"
    expect(page).to have_content "ユーザー無しピン詳細"

    fill_in "plan_pin_plan_pin_name" ,  with: ""

    click_on '更新'
    expect(page).to have_content "を入力してください"

    fill_in "plan_pin_plan_pin_name" ,  with: "ユーザー無し更新ピン名"
    fill_in "plan_pin_plan_pin_article" ,  with: "ユーザー無し更新ピン名"
    click_on '更新'
    expect(page).to have_content "更新に成功しました"
    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"
    expect(page).to have_content "ユーザー無し更新ピン名"
    expect(page).to have_content "ユーザー無し更新ピン名"
  end

  it "ピン更新（ユーザー有りピン）", js: true do

    #まずログイン
    login_as(user2)
    visit edit_plan_plan_pin_path(plan2.id,plan2_pin_with_user.id)
    # expect(page).to have_content "ユーザー有りピン名"
    expect(page).to have_content "ユーザー有りピン詳細"

    fill_in "plan_pin_plan_pin_name" ,  with: ""

    click_on '更新'
    expect(page).to have_content "を入力してください"

    fill_in "plan_pin_plan_pin_name" ,  with: "ユーザー有り更新ピン名"
    fill_in "plan_pin_plan_pin_article" ,  with: "ユーザー有り更新ピン名"
    click_on '更新'
    expect(page).to have_content "更新に成功しました"
    expect(page).not_to have_content "ユーザー有りピン名"
    expect(page).not_to have_content "ユーザー有りピン詳細"
    expect(page).to have_content "ユーザー有り更新ピン名"
    expect(page).to have_content "ユーザー有り更新ピン名"
  end

  it "ピン更新（自身のピン）", js: true do

    #まずログイン
    login_as(user2)
    visit edit_plan_plan_pin_path(plan2.id,plan2_pin_with_user2.id)
    # expect(page).to have_content "2の人のピン名"
    expect(page).to have_content "2の人のピン詳細"

    fill_in "plan_pin_plan_pin_name" ,  with: ""

    click_on '更新'
    expect(page).to have_content "を入力してください"

    fill_in "plan_pin_plan_pin_name" ,  with: "2の人の更新ピン名"
    fill_in "plan_pin_plan_pin_article" ,  with: "2の人の更新ピン名"
    click_on '更新'
    expect(page).to have_content "更新に成功しました"
    expect(page).not_to have_content "2の人のピン名"
    expect(page).not_to have_content "2の人のピン詳細"
    expect(page).to have_content "2の人の更新ピン名"
    expect(page).to have_content "2の人の更新ピン名"
  end


end
