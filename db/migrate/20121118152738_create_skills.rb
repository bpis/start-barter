class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :user_id
       t.string  :name
      t.boolean :visibility
       t.string  :proficiency

      t.timestamps
    end
  end
end
