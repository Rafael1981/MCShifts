class AddBonusToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :bonus, :time
  end
end
