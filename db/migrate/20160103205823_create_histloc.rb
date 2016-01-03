class CreateHistloc < ActiveRecord::Migration
  def change
    create_table :histlocs do |t|
      t.integer :log_id
      t.float :latitude
      t.float :longitude
      t.string :ip_address

      t.timestamps
    end
  end
end
