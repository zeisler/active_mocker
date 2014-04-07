require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection({
                                            :adapter => "sqlite3",
                                            database: ":memory:"
                                        })
require_relative 'db/schema'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/app/models/*.rb").each{|f| require f }