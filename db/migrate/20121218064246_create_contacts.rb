class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name,:last_name,:email
      t.text :message
      t.timestamps
    end
  end
end
