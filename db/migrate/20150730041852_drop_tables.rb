class DropTables < ActiveRecord::Migration
  def change
    drop_table :users
    drop_table :admins
  end
end
