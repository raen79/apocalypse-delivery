# frozen_string_literal: true

if ENV['BUCKETEER_AWS_ACCESS_KEY_ID']
  Paperclip::Attachment.default_options.merge!(
    storage: :fog,
    fog_credentials: {
      provider: 'AWS',
      aws_access_key_id: ENV['BUCKETEER_AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['BUCKETEER_AWS_SECRET_ACCESS_KEY'],
      region: ENV['BUCKETEER_AWS_REGION']
    },
    fog_directory: ENV['BUCKETEER_BUCKET_NAME']
  )

  Spree::Image.attachment_definitions[:attachment].delete(:url)
  Spree::Image.attachment_definitions[:attachment].delete(:path)
end
