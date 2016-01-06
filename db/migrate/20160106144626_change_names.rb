class ChangeNames < ActiveRecord::Migration
  def change
    rename_column :logs, :Signin, :signin
    rename_column :logs, :Signout, :signout
  end
end
