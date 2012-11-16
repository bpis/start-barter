class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name,   :null => false, :default => ""
      t.string :code,   :null => false, :default => ""

      t.timestamps
    end
  end
end
