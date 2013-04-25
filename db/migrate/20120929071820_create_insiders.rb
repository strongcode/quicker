class CreateInsiders < ActiveRecord::Migration
  def change
    create_table :insiders do |t|

      t.timestamps
    end
  end
end
