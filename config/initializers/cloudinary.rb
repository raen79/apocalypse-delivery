if ENV['CLOUDINARY_URL'] && ENV['CLOUDINARY_API_KEY'] && ENV['CLOUDINARY_API_SECRET']
  Cloudinary.config do |config|
    config.secure = true
    config.cdn_subdomain = true
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
  end
else
  Rails.logger.info { puts "****** Warning: There is no 'cloudinary' configuration info" }
end

module Cloudinary::CarrierWave
  def public_id
    return(
      "#{Rails.application.class.parent_name.downcase}/#{
        File.basename(@filename.downcase, File.extname(@filename.downcase))
      }-#{Cloudinary::Utils.random_public_id}"
    )
  end
end
