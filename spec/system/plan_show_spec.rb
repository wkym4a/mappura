require 'rails_helper'

RSpec.describe "Test name", type: :system do

  let!(:user) { FactoryBot.create(:user) }
  let!(:pin_no_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー無しピン名",pin_article: "ユーザー無しピン詳細") }
  let!(:pin_with_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー有りピン名",pin_article: "ユーザー有りピン詳細",user_id: user.id) }
  let!(:pin_with_user_not_public) { FactoryBot.create(:drawing_pin,pin_name: "非公開ピン名",pin_article: "非公開ピン詳細",user_id: user.id,public_div: 9) }

  let!(:user2) { FactoryBot.create(:user,user_name: "別人" ,email: "betu@test.co.jp") }
  let!(:plan2) { FactoryBot.create(:plan, plan_name: "プラン2名",user_id: user2.id) }
  let!(:plan2_pin_no_user) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_no_user.id) }
  let!(:plan2_pin_with_user) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_with_user.id) }
  let!(:plan2_pin_with_user_not_public) { FactoryBot.create(:plan_pin, plan_id: plan2.id,drawing_pin_id: pin_with_user_not_public.id) }

  it "そのプランを作成したユーザーでないと、入れない" do
    #プラン表示画面へ、ログインせずに入ろうとする
    visit plan_path(plan2.id)
    expect(page).to have_content "アカウント登録もしくはログインしてください"

    #プラン表示画面へ、別のユーザーで入ろうとする
    login_as(user)
    #プラン表示画面へ、ログインせずに入ろうとする
    visit plan_path(plan2.id)
    expect(page).to have_content "実行しようとした処理は権限がないか、データが存在しません"

  end

  it "ログイン者が「作業箱に追加→削除」「プランに追加→削除」", js: true do

    #まずログイン
    login_as(user2)
    visit plan_path(plan2.id)

    expect(page).to have_content "ユーザー無しピン名"
    expect(page).to have_content "ユーザー無しピン詳細"
    expect(page).to have_content "ユーザー有りピン名"
    expect(page).to have_content "ユーザー有りピン詳細"

    expect(page).not_to have_content "非公開ピン名"
    expect(page).not_to have_content "非公開ピン詳細"
    expect(page).to have_content "削除または非公開設定されました"

    within "#pin_id_#{pin_no_user.id}" do
      expect(page).to have_content "ユーザー無しピン名"
      expect(page).to have_content "ユーザー無しピン詳細"
      click_on '削除'
    end
    expect(page).to have_content "プラン「プラン2名」から📍を削除しました"
    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"

    within "#pin_id_#{pin_with_user.id}" do
      expect(page).to have_content "ユーザー有りピン名"
      expect(page).to have_content "ユーザー有りピン詳細"
      click_on '削除'
    end
    expect(page).to have_content "プラン「プラン2名」から📍を削除しました"
    expect(page).not_to have_content "ユーザー有りピン名"
    expect(page).not_to have_content "ユーザー有りピン詳細"

    expect(page).to have_content "削除または非公開設定されました"
    click_on '削除'
    expect(page).to have_content "プラン「プラン2名」から📍を削除しました"
    expect(page).not_to have_content "削除または非公開設定されました"

  end

end
