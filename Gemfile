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

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # 開発、検証用に追加
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'

  #メール送信テスト用に追加
  gem 'letter_opener_web'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
