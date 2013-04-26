class Manage::MenusController < Manage::ApplicationController
  actions :all, :except => [:index, :show]

  belongs_to :organization do
    belongs_to :meal, singleton: true
  end

  def smart_collection_url
    [:manage, @organization, :meal]
  end
end
