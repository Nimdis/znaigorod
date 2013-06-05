# encoding: utf-8

class Attachment < ActiveRecord::Base
  attr_accessible :file, :description

  belongs_to :attachable, :polymorphic => true

  default_scope :order => 'id ASC'

  before_create :set_description

  after_create :index_attachable
  after_destroy :index_attachable

  searchable do
    integer :id
    string :attachable_type
    string(:attachable_id_str) { attachable_id.to_s }
    string :category
    string :tags, :multiple => true
    string :type
    text :description
    time :created_at
  end

private

  def index_attachable
    attachable.index_additional_attributes if attachable.respond_to? :index_additional_attributes
  end

  def category
    attachable.class.model_name.human.mb_chars.downcase
  end

  def tags
    attachable.respond_to?(:tags) ? attachable.tags : []
  end

  def set_description
    self.description ||= File.basename(file_file_name, '.*').titleize
  end
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

