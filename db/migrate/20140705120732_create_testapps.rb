class CreateTestapps < ActiveRecord::Migration
  def self.up
    create_table :testapps do |t|
      t.string :appid
      t.string :appname

      t.timestamps
    end
  end

  def self.down
    drop_table :testapps
  end
end
