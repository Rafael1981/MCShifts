class AddPlaceToLogs < ActiveRecord::Migration
  def change
    add_reference :logs, :place, index: true
  end
end
