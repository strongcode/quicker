class PhotoUploader < Uploader

  version :standard_image do
    process :resize_to_fill => [90, 90]
  end

  version :small_image do
    process :resize_to_fill => [45, 45]
  end

  version :suggestion_image do
    process :resize_to_fill => [200, 121]
  end

end