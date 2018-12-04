class CreateScore < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
    	t.integer :user_id
    	t.string :score
    	t.timestamps
    end
  end
end
