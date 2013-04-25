class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :description
      t.string :language_sid
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
