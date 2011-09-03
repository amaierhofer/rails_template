require "colored"

%w[responders simple_form inherited_resources slim].each do |item|
  gem item
end

%w[compass fancy-buttons livereload active_reload pry].each do |item|
  gem item, :group => :development 
end

%w[compass fancy-buttons livereload active_reload].each do |item|
  gem item, :group => :test 
end

# rm -rf foo; rails new foo -m ~/rails_template/template.rb
# Directories for template partials and static files
@template_root = File.expand_path(File.join(File.dirname(__FILE__)))
@partials     = File.join(@template_root, 'partials')
@static_files = File.join(@template_root, 'files')

def copy_static_file(path)
  to = path.gsub(/^_/, ".")
  remove_file to
  file to, File.read(File.join(@static_files, path))
end

copy_static_file "spec_helper.rb"
copy_static_file "_livereload"

puts "Setting up RSpec ... ".magenta
remove_dir 'test'
generators = <<-RUBY
  config.generators do |generate|
      generate.test_framework   :rspec
    end
RUBY
application generators
