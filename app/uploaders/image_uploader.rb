class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  #画像保存先をS#にするため、変更
  storage :fog
  # storage :file

  process :resize_to_limit => [600,300]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def size_range
    1..5.megabytes
  end

end
