require 'rails_helper'


RSpec.describe Workbox, type: :model do

  let(:user) { FactoryBot.create(:user) }

    example "ワークボックス、単純登録……ユーザーなしだとエラー" do
      workbox = FactoryBot.build(:workbox)
      workbox.valid?
      expect(workbox.errors[:user]).to include("を入力してください")
    end
    example "ワークボックス、単純登録(ユーザーを設定して)" do
      expect(FactoryBot.build(:workbox,user_id: user.id)).to be_valid
    end

    example "ワークボックス、存在しないユーザーなしだとエラー" do
      workbox = FactoryBot.build(:workbox,user_id: user.id + 1)
      workbox.valid?
      expect(workbox.errors[:user]).to include("を入力してください")
    end

    example "ワークボックス登録_「ワークボックス名称」必須" do
      workbox = FactoryBot.build(:workbox,user_id: user.id,workbox_name: "")
      workbox.valid?
      expect(workbox.errors[:workbox_name]).to include("を入力してください")
    end

    example "ワークボックス登録_「ワークボックス名称」は最大12字（異常" do
      workbox = FactoryBot.build(:workbox,user_id: user.id,workbox_name: "a" * 13)
      workbox.valid?
      expect(workbox.errors[:workbox_name]).to include("は12文字以内で入力してください")
    end
    example "ワークボックス登録_「ワークボックス名称」は最大12字（正常" do
      expect(FactoryBot.build(:workbox,user_id: user.id,workbox_name: "a" * 12)).to be_valid
    end

end
