class CreateMeters < ActiveRecord::Migration
  def change
    create_table :meters do |t|
      t.string :reading

      t.timestamps null: false
    end
  end
end
