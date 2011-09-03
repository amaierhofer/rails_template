require "colored"
run "rvm use 1.9.3-head@rails31"

puts "Updating Gemfile .. ".magenta
data = <<EOF
group :development, :test do
  gem "hirb"
  gem "pry"
  gem "thin"
  gem "rb-inotify"
  gem "livereload"
  gem "libnotify"
  gem "active_reload"
  gem "spork", "0.9.0.rc9" 
  gem "factory_girl"
  gem "guard-rspec"
  gem "guard-spork"
  gem "capybara"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "rails_best_practices"
  gem "awesome_print"
end
gem "sqlite3"
gem "slim"
gem "pjax_rails"
gem "responders"
gem "simple_form"
gem "compass"
gem "fancy-buttons"
EOF
open("Gemfile", "a") do |f|
  f.puts data
end

# rm -rf foo; rails new foo -m ~/rails_template/template.rb
# Directories for template partials and static files
@template_root = File.expand_path(File.join(File.dirname(__FILE__)))
@partials     = File.join(@template_root, 'partials')
@static_files = File.join(@template_root, 'files')

def copy_static_file(path,dir = nil)
  to = path.gsub(/^_/, ".")
  remove_file to
  to = "#{dir}/#{to}" unless dir.nil?
  file to, File.read(File.join(@static_files, path)) 
end

copy_static_file "Guardfile"
copy_static_file "spec_helper.rb", "spec"
copy_static_file "_rvmrc"
copy_static_file "_livereload"
copy_static_file "_rspec"
copy_static_file "_gitignore"

puts "Setting up RSpec ... ".magenta
remove_dir 'test'
generators = <<-RUBY
  config.generators do |generate|
      generate.test_framework   :rspec
    end
RUBY
application generators

rake "db:migrate"
generate :controller, "home index"
remove_file "public/index.html"
remove_file "README"
