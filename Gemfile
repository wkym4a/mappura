source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

#bootstrapをgemで追加
gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails'

#親子を一括登録するためのnestedfield……'jquery-rails'は↑で追加済み。
gem 'nested_form_fields'

#ドラッグアンドドロップによる並び替え用
gem 'acts_as_list'
gem 'jquery-turbolinks'

#環境ファイル「.env」を管理するために追加
gem 'dotenv-rails'

#stimulus用に追加
gem 'webpacker'

#権限間利用に追加
gem 'devise'
gem 'cancancan'
gem 'rails_admin'

#画像管理用
gem 'carrierwave'
gem 'mini_magick'

#画像の保管先をs3にするため導入
gem 'fog-aws'

#SESでメールを送るため
gem 'aws-ses'

#ペジネーション用に追加
gem 'kaminari'

gem 'unicorn' # アプリケーションサーバのunicorn
gem 'mini_racer', platforms: :ruby # デプロイ時に必要

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'ed25519'
gem 'bcrypt_pbkdf'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # 開発、検証用に追加
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'

  #メール送信テスト用に追加
  gem 'letter_opener_web'

  #テスト用のジェム
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem 'spring-commands-rspec'

  #テストデータ作成用
  gem 'faker'
end

group :development do

  gem 'capistrano', '3.6.0' # capistranoのツール一式
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'

  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'

  #テスト後、データをクリアするジェム
  # gem 'database_cleaner'
  #テスト用のジェム（追加）
  gem 'launchy'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
