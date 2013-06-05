# encoding: utf-8

class PaperclipAttachment < ActiveRecord::Base
  belongs_to :attacheable, :polymorphic => true
  attr_accessible :attachment

  has_attached_file :attachment, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end

# == Schema Information
#
# Table name: paperclip_attachments
#
#  id                      :integer          not null, primary key
#  attacheable_id          :integer
#  attacheable_type        :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  attachment_url          :text
#  attachment_type         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

