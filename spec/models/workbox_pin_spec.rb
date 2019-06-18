require 'rails_helper'

RSpec.describe WorkboxPin, type: :model do

  let(:drawing_pin1) { FactoryBot.create(:drawing_pin) }
  let(:user) { FactoryBot.create(:user) }
  let(:workbox) { FactoryBot.create(:workbox,user_id: user.id) }

  example "作業箱ピン登録……作業箱なしだとエラー" do
    workbox_pin = FactoryBot.build(:workbox_pin,drawing_pin_id: drawing_pin1.id)
    workbox_pin.valid?
    expect(workbox_pin.errors[:workbox]).to include("を入力してください")
  end

  example "作業箱ピン登録……ピンなしでも登録可能（ピン削除した場合、「基のピンが削除された」旨を残すため" do
    expect(FactoryBot.build(:workbox_pin,workbox_id: workbox.id)).to be_valid

  end

  example "作業箱ピン登録（通常……「作業箱」「ピン」両方を持つ" do
    expect(FactoryBot.build(:workbox_pin,workbox_id: workbox.id,drawing_pin_id: drawing_pin1.id)).to be_valid

  end

  example "作業箱ピン登録……存在しない作業箱だとエラー" do
    workbox_pin = FactoryBot.build(:workbox_pin,workbox_id: workbox.id + 1,drawing_pin_id: drawing_pin1.id)
    workbox_pin.valid?
    expect(workbox_pin.errors[:workbox]).to include("を入力してください")
  end

  example "作業箱ピン登録……ちなみに、存在しないピンでも登録可能" do
    expect(FactoryBot.build(:workbox_pin,workbox_id: workbox.id,drawing_pin_id: drawing_pin1.id + 1)).to be_valid
  end

end
