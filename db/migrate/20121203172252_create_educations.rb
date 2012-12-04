class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :user_id
      t.string :school_name
      t.string :field_of_study
      t.string :start_date
      t.string :end_date
      t.string :grade
      t.string :activities
      t.string :notes
       t.string :degree
      t.timestamps
    end
  end
end
