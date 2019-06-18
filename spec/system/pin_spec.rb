require 'rails_helper'

RSpec.describe "Test name", type: :system do
  it "システムスペックのテストがちゃんと動くことを確認" do


        expect("っっっｂ").to eq "っっっｂ"

  end


  it "JSのテスト（含、stimulus)がちゃんと動くことを確認_確認前", js: true do

    visit new_drawing_pin_path

    find('#btn_set_by_latlng').click

    expect(page).to have_content "緯度、経度を入力してください"

  end

end
