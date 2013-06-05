# encoding: utf-8

class Role < ActiveRecord::Base
  extend Enumerize

  attr_accessible :role, :user_id

  belongs_to :user

  enumerize :role, in: [:admin, :affiches_editor, :organizations_editor, :posts_editor, :sales_manager]
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

