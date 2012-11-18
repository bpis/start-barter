class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :company_name
      t.string :tagline
      t.string :github_profile_link
      t.string :overview
      t.string :job_profile
      t.string :keyword
      t.string :phone_no
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.integer :zip

      t.timestamps
    end
  end
end
