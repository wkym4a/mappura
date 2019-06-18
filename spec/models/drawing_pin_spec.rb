require 'rails_helper'

RSpec.describe DrawingPin, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"


  let(:user) { FactoryBot.create(:user) }

  example "モデルテストがちゃんと動くことを確認" do

    expect("aaaaaa").to eq "aaaaaa"

  end

  example "ピン、単純登録" do
    expect(FactoryBot.build(:drawing_pin)).to be_valid
  end

  example "ピン登録_「ユーザーのピン」として" do
    expect(FactoryBot.build(:drawing_pin,user_id: user.id)).to be_valid
  end

  example "ピン登録_「ピン名称」必須" do
    drawing_pin = FactoryBot.build(:drawing_pin,pin_name: "")
    drawing_pin.valid?
    expect(drawing_pin.errors[:pin_name]).to include("を入力してください")
  end

  example "ピン登録_「ピン名称」は最大30字（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,pin_name: "a" * 31)
    drawing_pin.valid?
    expect(drawing_pin.errors[:pin_name]).to include("は30文字以内で入力してください")
  end

  example "ピン登録_「ピン名称」は最大30字（正常" do
    expect(FactoryBot.build(:drawing_pin,pin_name: "a" * 30)).to be_valid
  end

  example "ピン登録_「ピン記事」未入力登録可能" do
    expect(FactoryBot.build(:drawing_pin,pin_article: "")).to be_valid
  end

  example "ピン登録_「ピン記事」は最大180字（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,pin_article: "a" * 181)
    drawing_pin.valid?
    expect(drawing_pin.errors[:pin_article]).to include("は180文字以内で入力してください")
  end

  example "ピン登録_「ピン記事」は最大180字（正常" do
    expect(FactoryBot.build(:drawing_pin,pin_article: "a" * 180)).to be_valid
  end

  example "ピン登録_「住所」未入力登録可能" do
    expect(FactoryBot.build(:drawing_pin,address: "")).to be_valid
  end

  example "ピン登録_「住所」は最大255字（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,address: "a" * 256)
    drawing_pin.valid?
    expect(drawing_pin.errors[:address]).to include("は255文字以内で入力してください")
  end

  example "ピン登録_「住所」は最大255字（正常" do
    expect(FactoryBot.build(:drawing_pin,address: "a" * 255)).to be_valid
  end
  example "ピン登録_「緯度」は「-90」以上（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,latitude: -90.01)
    drawing_pin.valid?
    expect(drawing_pin.errors[:latitude]).to include("は-90以上の値にしてください")
  end
  example "ピン登録_「緯度」は「-90」以上（正常" do
    expect(FactoryBot.build(:drawing_pin,latitude: -90)).to be_valid
  end
  example "ピン登録_「緯度」は「90」以下（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,latitude: 90.01)
    drawing_pin.valid?
    expect(drawing_pin.errors[:latitude]).to include("は90以下の値にしてください")
  end
  example "ピン登録_「緯度」は「90」以下（正常" do
    expect(FactoryBot.build(:drawing_pin,latitude: 90)).to be_valid
  end

  example "ピン登録_「経度」は「-180」以下（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,longitude: -180.01)
    drawing_pin.valid?
    expect(drawing_pin.errors[:longitude]).to include("は-180以上の値にしてください")
  end
  example "ピン登録_「経度」は「-180」以下（正常" do
    expect(FactoryBot.build(:drawing_pin,longitude: -180)).to be_valid
  end
  example "ピン登録_「経度」は「180」以下（異常" do
    drawing_pin = FactoryBot.build(:drawing_pin,longitude: 180.01)
    drawing_pin.valid?
    expect(drawing_pin.errors[:longitude]).to include("は180以下の値にしてください")
  end
  example "ピン登録_「経度」は「180」以下（正常" do
    expect(FactoryBot.build(:drawing_pin,longitude: 180)).to be_valid
  end


end
