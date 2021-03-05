if %w[development test].include?(ENV['RAILS_ENV'])
  require 'rubygems'
  require 'active_record'
  ActiveRecord::Base.logger = Logger.new($stdout)
  ActiveRecord::Base.connection
end
