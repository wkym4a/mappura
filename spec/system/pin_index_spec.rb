require 'rails_helper'

RSpec.describe "Test name", type: :system do


  let!(:user) { FactoryBot.create(:user) }
  let!(:pin_no_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー無しピン名",pin_article: "ユーザー無しピン詳細") }
  let!(:pin_with_user) { FactoryBot.create(:drawing_pin,pin_name: "ユーザー有りピン名",pin_article: "ユーザー有りピン詳細",user_id: user.id) }
  let!(:pin_with_user_not_public) { FactoryBot.create(:drawing_pin,pin_name: "非公開ピン名",pin_article: "非公開ピン詳細",user_id: user.id,public_div: 9) }

  let!(:plan1) { FactoryBot.create(:plan,plan_name: "プラン名",user_id: user.id) }
  let!(:workbox1) { FactoryBot.create(:workbox,workbox_name: "作業箱名",user_id: user.id) }


  it "ピン検索のテストがちゃんと動くことを確認" do
        expect("っっっｂ").to eq "っっっｂ"

  end

  it "ログイン者が「作業箱に追加→削除」「プランに追加→削除」", js: true do
    #まずログイン
    login_as(user)

    visit drawing_pins_path
    #一覧画面に移動し、（ログインしているので「ログインしているユーザー」の条件で）検索
    find('#btn_search').click

    #自分が作った非公開ピンは検索される
    within "#pin_id_#{pin_with_user_not_public.id}" do
      expect(page).to have_content "非公開ピン名"
      expect(page).to have_content "非公開ピン詳細"
    end

    expect(page).not_to have_content "ユーザー無しピン名"
    expect(page).not_to have_content "ユーザー無しピン詳細"

    within "#pin_id_#{pin_with_user.id}" do

      expect(page).not_to have_content "ユーザー無しピン名"
      expect(page).not_to have_content "ユーザー無しピン詳細"

      expect(page).to have_content "ユーザー有りピン名"
      expect(page).to have_content "ユーザー有りピン詳細"

      within ".index_grid_item_line_1" do
        expect(page).to have_content "作業箱名"
      end

      within ".index_grid_item_line_2" do
        expect(page).to have_content "プラン名"
      end

    end


    within "#pin_id_#{pin_with_user.id}" do
      #作業箱にピンを追加
      within ".index_grid_item_line_1" do
        click_on 'に追加'
      end
    end
    expect(page).to have_content "作業箱「作業箱名」にぴんを登録しました。"

    within "#pin_id_#{pin_with_user.id}" do
      #作業箱からピンを削除
      within ".index_grid_item_line_1" do
        click_on 'から削除'
      end

    end
    expect(page).to have_content "作業箱「作業箱名」からぴんを削除しました。"

    #プランにピンを追加
    within "#pin_id_#{pin_with_user.id}" do
      within ".index_grid_item_line_2" do
        click_on 'に追加'
      end
    end
    expect(page).to have_content "プラン「プラン名」にぴんを登録しました。"

    #プランからピンを削除
    within "#pin_id_#{pin_with_user.id}" do
      within ".index_grid_item_line_2" do
        click_on 'から削除'
      end
    end
    expect(page).to have_content "プラン「プラン名」からぴんを削除しました。"


  end


  it "非ログイン者で検索", js: true do
    #ログインしないまま、
    visit drawing_pins_path
    #一覧画面に移動し、（ログインしていないので、検索条件無しで）検索
    find('#btn_search').click

    #非公開ピンは検索されない
    expect(page).not_to have_content "非公開ピン名"
    expect(page).not_to have_content "非公開ピン詳細"
    expect(page).to have_content "ユーザー無しピン名"
    expect(page).to have_content "ユーザー無しピン詳細"

    expect(page).to have_content "ユーザー有りピン名"
    expect(page).to have_content "ユーザー有りピン詳細"

    within "#pin_id_#{pin_with_user.id}" do

      expect(page).to have_content "ユーザー有りピン名"
      expect(page).to have_content "ユーザー有りピン詳細"

      #検索されたピンについても作業箱、プランへの出し入れは出来ない
      expect(page).not_to have_content "作業箱名"
      expect(page).not_to have_content "プラン名"
    end


  end


  it "別のユーザーが「作業箱に追加→削除」「プランに追加→削除」", js: true do

    user2 = FactoryBot.create(:user,user_name: "別人" ,email: "betu@test.co.jp")
    plan2 = FactoryBot.create(:plan, plan_name: "プラン2名",user_id: user2.id)
    workbox2 =  FactoryBot.create(:workbox,workbox_name: "作業箱2名",user_id: user2.id)

    #別のユーザーでログイン
    login_as(user2)

    visit drawing_pins_path
    find('#conditions_user_name').set("")
    #一覧画面に移動し、（検索条件無しにして）検索
    find('#btn_search').click

    #非公開ピンは検索されない
    expect(page).not_to have_content "非公開ピン名"
    expect(page).not_to have_content "非公開ピン詳細"

    expect(page).to have_content "ユーザー無しピン名"
    expect(page).to have_content "ユーザー無しピン詳細"

    within "#pin_id_#{pin_with_user.id}" do

      expect(page).to have_content "ユーザー有りピン名"
      expect(page).to have_content "ユーザー有りピン詳細"

      within ".index_grid_item_line_1" do
        expect(page).to have_content "作業箱2名"
      end

      within ".index_grid_item_line_2" do
        expect(page).to have_content "プラン2名"
      end

    end


    within "#pin_id_#{pin_with_user.id}" do
      #作業箱にピンを追加
      within ".index_grid_item_line_1" do
        click_on 'に追加'
      end
    end
    expect(page).to have_content "作業箱「作業箱2名」にぴんを登録しました。"

    within "#pin_id_#{pin_with_user.id}" do
      #作業箱からピンを削除
      within ".index_grid_item_line_1" do
        click_on 'から削除'
      end

    end
    expect(page).to have_content "作業箱「作業箱2名」からぴんを削除しました。"

    #プランにピンを追加
    within "#pin_id_#{pin_with_user.id}" do
      within ".index_grid_item_line_2" do
        click_on 'に追加'
      end
    end
    expect(page).to have_content "プラン「プラン2名」にぴんを登録しました。"

    #プランからピンを削除
    within "#pin_id_#{pin_with_user.id}" do
      within ".index_grid_item_line_2" do
        click_on 'から削除'
      end
    end
    expect(page).to have_content "プラン「プラン2名」からぴんを削除しました。"


  end



end
