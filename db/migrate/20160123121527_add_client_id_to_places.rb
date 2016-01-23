class AddClientIdToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :client_id, :integer
  end
end
