class CreateSgPages < ActiveRecord::Migration
  def change
    create_table :sg_pages do |t|
      t.string :name
      t.timestamps
    end
  end
end
