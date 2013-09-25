# encoding: utf-8

module ShareVkHelper
  def data_attachments(item)
    if item.is_a?(Afisha)
      "#{item.poster_vk_id},#{afisha_show_url(item)}"
    elsif item.is_a?(Organization)
      "#{oganization_url(item)}"
    end
  end
end

