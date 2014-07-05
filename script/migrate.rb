ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require "active_record/connection_adapters/abstract/connection_specification.rb"
require 'anwschema.rb'
require 'bomigration.rb'


