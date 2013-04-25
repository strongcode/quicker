class CreateSidekicks < ActiveRecord::Migration
  def change
    create_table :sidekicks do |t|

      t.timestamps
    end
  end
end
