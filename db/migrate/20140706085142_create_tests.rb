class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tests
  end
end
