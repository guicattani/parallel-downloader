# frozen_string_literal: true
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "httparty"
gem "parallel"
gem "ruby-progressbar"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rubocop-performance", require: false
end

group :development do
  gem "guard-rspec", require: false
end

group :test do
  gem "rubocop-rspec", require: false
  gem "rspec"
  gem "simplecov"
  gem "vcr"
  gem "webmock"
end
