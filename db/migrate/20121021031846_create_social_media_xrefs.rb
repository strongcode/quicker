class CreateSocialMediaXrefs < ActiveRecord::Migration
  def change
    create_table :social_media_xrefs do |t|
      t.string    :social_media_source
      t.string    :source_media_keywords
      t.datetime  :deleted_at

      t.timestamps
    end
  end
end
