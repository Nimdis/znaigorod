class Showing < ActiveRecord::Base
  attr_accessible :ends_at, :hall, :place, :price_max, :price_min, :starts_at, :organization_id, :latitude, :longitude, :affiche_id

  belongs_to :affiche
  belongs_to :organization

  validates_presence_of :place, :starts_at

  delegate :created_at, :distribution_starts_on, :popularity, :tags, :title, :age_min, :age_max, :to => :affiche, :prefix => true
  delegate :address, :title, :to => :organization, :prefix => true, :allow_nil => true

  after_create  :index_affiche
  after_destroy :index_affiche

  scope :actual, -> { where('starts_at >= ? OR (ends_at is not null AND ends_at > ?)', DateTime.now.beginning_of_day, Time.zone.now) }

  scope :with_organization, where('organization_id IS NOT NULL')

  default_value_for :price_max, nil
  default_value_for :price_min, nil

  searchable do
    date :starts_on

    float :affiche_popularity

    integer :affiche_id
    integer :organization_id
    integer :price_max
    integer :price_min
    integer(:age_max) { affiche_age_max }
    integer(:age_min) { affiche_age_min }
    integer(:ends_at_hour) { ends_at.try(:hour) }
    integer(:organization_ids, :multiple => true) { [organization_id] if organization_id? }
    integer(:starts_at_hour) { starts_at.hour }

    string(:affiche_category) { affiche.class.model_name.downcase }
    string(:affiche_id_str) { affiche_id.to_s }
    string(:categories, :multiple => true) { [affiche.class.model_name.downcase] }
    string(:tags, :multiple => true) { affiche_tags.delete_if(&:blank?) }

    text :affiche_title
    text :organization_title
    text :place

    time :affiche_created_at, :trie => true
    time :affiche_distribution_starts_on, :trie => true
    time :ends_at
    time :starts_at, :trie => true
  end

  def ends_on
    ends_at.try :to_date
  end

  def starts_on
    starts_at.to_date
  end

  def during_several_days?
    ends_on ? starts_on != ends_on : false
  end

  def self.tags
    search_params = { :starts_on_greater_than => Date.today, :starts_on_less_than => Date.today + 4.weeks }
    HasSearcher.searcher(:showing, search_params).faceted.facet(:tags).rows.map(&:value)
  end

  def self.nearest
    HasSearcher.searcher(:showing).actual.today.order(:starts_at).limit(5)
  end

  def get_longitude
    organization_address.try(:longitude) || longitude
  end

  def get_latitude
    organization_address.try(:latitude) || latitude
  end

  private
    def index_affiche
      affiche.index
    end
end

# == Schema Information
#
# Table name: showings
#
#  id              :integer          not null, primary key
#  affiche_id      :integer
#  place           :string(255)
#  starts_at       :datetime
#  price_min       :integer
#  hall            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ends_at         :datetime
#  price_max       :integer
#  organization_id :integer
#  latitude        :string(255)
#  longitude       :string(255)
#

