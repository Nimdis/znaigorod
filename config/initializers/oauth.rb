Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, Settings[:vk][:app_id], Settings[:vk][:app_secret]
end
