require "colored"
run "rvm use 1.9.3-head@rails31"

inject_into_file "Gemfile", :after => "end\n\n" do
  <<-RUBY
  group :development, :test do
    gem "hirb"
    gem "pry-rails"
    gem "thin"
    gem "rb-inotify"
    gem "hirb"
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
  gem "slim-rails"
  gem "pjax_rails"
  gem "responders"
  gem "has_scope"
  gem "inherited_resources"
  gem "simple_form"
  gem "compass"
  gem "fancy-buttons"
    RUBY
end

inject_into_file 'config/application.rb', :before => "  end\nend" do
  <<-RUBY
    # Turn off timestamped migrations
    config.active_record.timestamped_migrations = false
  RUBY
end

inject_into_file 'config/environments/development.rb', :before => "\nend" do
  <<-RUBY
    # pretty print slim output in dev mode
    Slim::Engine.set_default_options :pretty => true
  RUBY
end

inject_into_file "config/routes.rb", "\n\troot :to => 'home#index'", :before => "\nend"

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
copy_static_file "run-services", "bin"
copy_static_file "application.html.slim", "app/views/layouts"
copy_static_file "error_messages_helper.rb", "app/helpers"
copy_static_file "layout_helper.rb", "app/helpers"
run "chmod 755 bin/run-services"

rake "db:migrate"
generate :controller, "home index"
remove_file "app/views/layouts/application.html.erb"
remove_file "public/index.html"
remove_file "README"
remove_dir 'test'

run "bundle install --binstubs"
