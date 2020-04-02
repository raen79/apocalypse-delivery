if ENV['CLOUDINARY_URL']
  Cloudinary.config do |config|
    config.secure = true
    config.cdn_subdomain = true
  end
else
  Rails.logger.info { puts "****** Warning: There is no 'cloudinary' configuration info" }
end
