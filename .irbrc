# if %w(development test).include?(ENV['RAILS_ENV'])
#   require 'rubygems'
#   require 'hirb'
#   require 'active_record'
#   require 'awesome_print'
#   Hirb.enable
#   AwesomePrint.irb!
#   ActiveRecord::Base.logger = Logger.new(STDOUT)
#   ActiveRecord::Base.connection
# end