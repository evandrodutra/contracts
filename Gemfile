source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.1.4"
gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "bcrypt", "~> 3.1.7"
gem "active_model_serializers", "~> 0.10.0"
gem "jwt"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 3.7"
  gem "pry"
  gem "pry-byebug"
  gem "rubocop", "~> 0.51.0", require: false
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
end

group :test do
  gem "json_matchers"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
end
