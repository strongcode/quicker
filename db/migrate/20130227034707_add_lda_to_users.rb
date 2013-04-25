class AddLdaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lda, :datetime, :default => Time.now
  end
end
