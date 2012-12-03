class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.integer :user_id
      t.string :company_name
      t.string :title
      t.string :location
       t.string :start_date
       t.string :end_date
      t.boolean :is_current
      t.string :description

      t.timestamps
    end
  end
end
