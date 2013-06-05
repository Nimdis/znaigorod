# encoding: utf-8

class Image < ActiveRecord::Base
end

# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  url            :text
#  imageable_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :text
#  imageable_type :string(255)
#  thumbnail_url  :string(255)
#  width          :integer
#  height         :integer
#

