class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :Signin
      t.datetime :Signout

      t.timestamps
    end
  end
end
