class AddIamAndIamLookingForColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :iam, :text
    add_column :users, :iamlookingfor, :text
  end
end
