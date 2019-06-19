require 'rails_helper'

RSpec.describe PlanPin, type: :model do

  let(:drawing_pin1) { FactoryBot.create(:drawing_pin) }
  let(:user) { FactoryBot.create(:user) }
  let(:plan) { FactoryBot.create(:plan,user_id: user.id) }

  example "プランピン登録……プランなしだとエラー" do
    plan_pin = FactoryBot.build(:plan_pin,drawing_pin_id: drawing_pin1.id)
    plan_pin.valid?
    expect(plan_pin.errors[:plan]).to include("を入力してください")
  end

  example "プランピン登録……ピンなしでも登録可能（ピン削除した場合、「基のピンが削除された」旨を残すため……ただし、「plan_pin_name」に値は必要" do
    expect(FactoryBot.build(:plan_pin,plan_id: plan.id , plan_pin_name: "damy" , plan_pin_article: "")).to be_valid

  end

  example "プランピン登録……「プラン」「ピン」両方を持つ" do
    expect(FactoryBot.build(:plan_pin,plan_id: plan.id,drawing_pin_id: drawing_pin1.id)).to be_valid
  end

  example "プランピン登録……登録時は「ピン」から「名称」「詳細」情報を引っ張ってくる" do
    plan_pin = FactoryBot.build(:plan_pin,plan_id: plan.id,drawing_pin_id: drawing_pin1.id)

    plan_pin.valid?
    expect(plan_pin.plan_pin_name).to eq(drawing_pin1.pin_name)
    expect(plan_pin.plan_pin_article).to eq(drawing_pin1.pin_article)
  end



end
