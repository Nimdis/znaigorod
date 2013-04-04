class Role < ActiveRecord::Base
  extend Enumerize

  attr_accessible :role, :user_id

  belongs_to :user

  enumerize :role, in: [:admin, :affiches_editor, :organizations_editor, :posts_editor, :sales_manager]
end
