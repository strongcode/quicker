class CreateMasterKeywords < ActiveRecord::Migration
  def change
    create_table :master_keywords do |t|
      t.string  :keyword
      t.integer :goal_advice_id
      t.string  :category
      t.timestamps
    end
  end
end
