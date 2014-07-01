ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
config={
    :adapter=> odbc1
    :dsn=> DSN1
    :username=> system
    :password=> manager
    :column_store=> true
    #:schema=> I027910_MASTER2   
}
ActiveRecord::Base.establish_connection(ConnectionSpecification.new(config, "odbc_connection"))

ActiveRecord::Base.connection.execute("select * from \"I027910_MASTER\".\"apps\"")

ActiveRecord::Schema.define(:version => 20140514091125) do

  create_table "apps", :force => true do |t|
    t.string   "appid"
    t.string   "name"
    t.string   "desc"
    t.integer  "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["appid"], :name => "index_apps_on_appid", :unique => true
  add_index "apps", ["name"], :name => "index_apps_on_name", :unique => true

end