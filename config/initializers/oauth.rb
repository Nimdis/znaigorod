Rails.application.config.middleware.use OmniAuth::Builder do
  use = Settings[:vk][:use]

  provider :vkontakte, Settings[:vk][use][:app_id], Settings[:vk][use][:app_secret]
end
