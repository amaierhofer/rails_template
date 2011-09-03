require "rubygems"
require "spork"
require "awesome_print"

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)
  require "rspec/rails"
  ActiveRecord::Migration.verbose = false
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
  end

   # Pre-loading for performance:
  require "rspec/mocks"
  require "rspec/core/expecting/with_rspec"
  require "rspec/core/formatters/documentation_formatter"
  require "rspec/core/formatters/base_text_formatter"
  require "rspec/core/mocking/with_rspec"
  require "rspec/core/expecting/with_rspec"
  require "rspec/expectations"
  require "rspec/matchers"
  require "active_support/secure_random"

  ## use this to trace require calls
   #module Kernel
    #def require_with_trace(*args)
      #start = Time.now.to_f
      #@indent ||= 0
      #@indent += 2
      #require_without_trace(*args)
      #@indent -= 2
      #Kernel::puts "#{" "*@indent}#{((Time.now.to_f - start)*1000).to_i} #{args[0]}"
    #end
    #alias_method_chain :require, :trace
 #end
end

def run_with_stopwatch(text)
  start = Time.now.to_f
  yield
  puts "#{text}: #{((Time.now.to_f - start)*1000).to_i}ms"
end

Spork.each_run do
  run_with_stopwatch "in-memory db" do
    load "#{Rails.root}/db/schema.rb"
    load "#{Rails.root}/db/seeds.rb"
  end

  run_with_stopwatch "app files" do
    begin
      Dir[Rails.root.join("spec/support/*.rb")].each {|f| load f}
      Dir[Rails.root.join("lib/*.rb")].each {|f| load f}
      Dir[Rails.root.join("app/controllers/*.rb")].each {|f| load f}
      Dir[Rails.root.join("app/models/*.rb")].each {|f| load f}
    rescue 
      puts "Error"
    end
  end
end
