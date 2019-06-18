require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:user) { FactoryBot.create(:user) }

  example "プラン、単純登録……ユーザーなしだとエラー" do
    plan = FactoryBot.build(:plan)
    plan.valid?
    expect(plan.errors[:user]).to include("を入力してください")
  end
  example "プラン、単純登録、単純登録(ユーザーを設定して)" do
    expect(FactoryBot.build(:plan,user_id: user.id)).to be_valid
  end
  example "プラン、存在しないユーザーなしだとエラー" do
    plan = FactoryBot.build(:plan,user_id: user.id + 1)
    plan.valid?
    expect(plan.errors[:user]).to include("を入力してください")
  end
  example "プラン登録_「プラン名称」必須" do
    plan = FactoryBot.build(:plan,user_id: user.id,plan_name: "")
    plan.valid?

    expect(plan.errors[:plan_name]).to include("を入力してください")
  end
  example "プラン登録_「プラン名称」は最大20字（異常" do
    plan = FactoryBot.build(:plan,user_id: user.id,plan_name: "a" * 21)
    plan.valid?

    expect(plan.errors[:plan_name]).to include("は20文字以内で入力してください")
  end
  example "プラン登録_「プラン名称」は最大20字（正常" do
    expect(FactoryBot.build(:plan,user_id: user.id,plan_name: "a" * 20)).to be_valid
  end

  example "プラン登録_「非公開」にして【更新する】場合、パスワード必須" do
    plan = FactoryBot.build(:plan,user_id: user.id,public_div: 9 ,password: "")

    # 新規登録時は「公開＋パスワードなし」、
    # パスワードの存在チェックを行うのは「更新（update）」時の「chk_password_existence」
    # （「valid?」ではない）
    plan.chk_password_existence

    expect(plan.errors[:password][0]).to include("「非公開」にする場合はパスワードを設定してください")
  end
  example "プラン登録_「パスワード」は最大40字（異常" do
    plan = FactoryBot.build(:plan,user_id: user.id,public_div: 9 ,password: "a" * 41)
    plan.valid?

    expect(plan.errors[:password]).to include("は40文字以内で入力してください")
  end
  example "プラン登録_「パスワード」は最大40字（正常" do
    expect(FactoryBot.build(:plan,user_id: user.id,public_div: 9 ,password: "a" * 40)).to be_valid
  end

end
