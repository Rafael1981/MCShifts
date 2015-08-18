class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :firstname
    	t.string :middlename
    	t.string :lastname
    	t.string :email
    	t.string :role
    	t.string :password_digest

      t.timestamps
    end
  end
end
