# encoding: utf-8

class GallerySocialImage < Attachment
  attr_accessible :file_url, :thumbnail_url
end

# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  attachable_id   :integer
#  attachable_type :string(255)
#  url             :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

