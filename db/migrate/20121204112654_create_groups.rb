class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :name
      t.string :membership_state

      t.timestamps
    end
  end
end
