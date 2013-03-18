# == Schema Information
#
# Table name: organizations
#
#  id                            :integer          not null, primary key
#  title                         :text
#  site                          :text
#  email                         :text
#  description                   :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  phone                         :text
#  vfs_path                      :string(255)
#  organization_id               :integer
#  logotype_url                  :text
#  slug                          :string(255)
#  tour_link                     :text
#  rating                        :float
#  non_cash                      :boolean
#  priority_suborganization_kind :string(255)
#  comment                       :text
#  additional_rating             :integer
#  yandex_metrika_page_views     :integer
#  vkontakte_likes               :integer
#  subdomain                     :string(255)
#  user_id                       :integer
#  status                        :string(255)
#

class Organization < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :address_attributes, :description, :email, :halls_attributes,
                  :images_attributes, :organization_id, :phone, :schedules_attributes,
                  :site, :subdomain, :title, :vfs_path, :attachments_attributes,
                  :logotype_url, :tour_link, :non_cash, :priority_suborganization_kind,
                  :comment, :organization_stand_attributes, :additional_rating,
                  :social_links_attributes,
                  :user_id

  # <=== CRM

  belongs_to :manager, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :organization
  has_many :activities, :dependent => :destroy
  has_many :contacts,   :dependent => :destroy

  extend Enumerize
  enumerize :status, :in => [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation], default: :fresh

  # CRM ===>

  has_many :affiches,       :through => :showings, :uniq => true
  has_many :halls,          :dependent => :destroy
  has_many :images,         :as => :imageable,  :dependent => :destroy
  has_many :attachments,    :as => :attachable, :dependent => :destroy
  has_many :organizations,  :dependent => :destroy
  has_many :schedules,      :dependent => :destroy
  has_many :sauna_halls,    :through => :sauna
  has_many :showings,       :dependent => :destroy
  has_many :social_links,   :dependent => :destroy

  has_one :address,             :dependent => :destroy
  has_one :culture,             :dependent => :destroy
  has_one :entertainment,       :dependent => :destroy, :conditions => { type: nil }
  has_one :meal,                :dependent => :destroy
  has_one :sauna,               :dependent => :destroy
  has_one :sport,               :dependent => :destroy
  has_one :billiard,            :dependent => :destroy
  has_one :creation,            :dependent => :destroy
  has_one :organization_stand,  :dependent => :destroy

  validates_presence_of :title, :priority_suborganization_kind

  validates  :email, :email_format => {
    :message => I18n.t('activerecord.errors.messages.invalid'),
    :allow_nil => true,
    :allow_blank => true
  }

  validates :site, :format => URI::regexp(%w(http https)), :if => :site?

  validates :phone, :phone => true, :if => :phone?

  accepts_nested_attributes_for :address,             :reject_if => :all_blank
  accepts_nested_attributes_for :attachments,         :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :halls,               :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :images,              :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :organization_stand,  :reject_if => :all_blank
  accepts_nested_attributes_for :schedules,           :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :social_links,        :reject_if => :all_blank, :allow_destroy => true

  delegate :category, :cuisine, :feature, :offer, :payment,
           :to => :meal, :allow_nil => true, :prefix => true

  delegate :category, :feature, :offer, :payment,
           :to => :entertainment, :allow_nil => true, :prefix => true

  delegate :latitude, :longitude, :to => :address, :allow_nil => true

  scope :ordered_by_updated_at, order('updated_at DESC')
  scope :parental,              where(:organization_id => nil)

  before_save :set_rating
  after_save :index_suborganizations

  alias_attribute :to_s, :title

  #default_value_for :yandex_metrika_page_views, 0
  #default_value_for :vkontakte_likes,           0

  friendly_id :title, use: :slugged

  paginates_per Settings['pagination.per_page'] || 10

  normalize_attribute :email, :with => [:strip, :blank]
  normalize_attribute :site,  :with => [:strip, :blank]

  alias_attribute :poster_url, :logotype_url
  alias_attribute :title_ru, :title
  alias_attribute :title_translit, :title
  alias_attribute :category_ru, :category
  alias_attribute :cuisine_ru, :cuisine
  alias_attribute :feature_ru, :feature
  alias_attribute :offer_ru, :offer
  alias_attribute :payment_ru, :payment
  alias_attribute :address_ru, :address

  searchable do
    float :rating

    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

    string :status
    integer :user_id
    string(:suborganizations, :multiple => true) { suborganizations.map(&:class).map(&:name).map(&:downcase) }

    string(:kind) { 'organization' }

    text :title,                :boost => 1.0 * 1.2
    text :title_ru,             :boost => 1.0,              :more_like_this => true
    text :title_translit,       :boost => 0.0,                                        :stored => true
    text :category,             :boost => 0.5 * 1.2
    text :category_ru,          :boost => 0.5 * 1
    text :cuisine,              :boost => 0.5 * 1.2
    text :cuisine_ru,           :boost => 0.5 * 1,          :more_like_this => true,  :stored => true
    text :feature,              :boost => 0.5 * 1.2
    text :feature_ru,           :boost => 0.5 * 1,          :more_like_this => true,  :stored => true
    text :offer,                :boost => 0.5 * 1.2
    text :offer_ru,             :boost => 0.5 * 1,          :more_like_this => true,  :stored => true
    text :payment,              :boost => 0.5 * 1.2
    text :payment_ru,           :boost => 0.5 * 1,                                    :stored => true
    text :address,              :boost => 0.3 * 1.2
    text :address_ru,           :boost => 0.3,                                        :stored => true
    text :description,          :boost => 0.1 * 1.2                                                     do text_description end
    text :description_ru,       :boost => 0.1,                                        :stored => true   do text_description end

    text(:services_info) { services.map { |s| "#{s.title} #{s.description} #{s.category} #{s.feature}" }.join(' ') }
    text :term
  end

  def term
   "#{title}, #{address}"
  end

  def as_json(options)
    super(:only => :id, :methods => :term)
  end

  def nearest_affiches
    Affiche.where :id => Showing.unscoped.where('starts_at > :now AND organization_id = :organization_id',
                  { :now => DateTime.now.utc, :organization_id => id }).group(:affiche_id).pluck(:affiche_id)
  end

  def cuisine
    meal_cuisine
  end

  %w[category feature offer payment].each do |method|
    define_method method do
      suborganizations.map { |s| s.send(method) if s.respond_to?(method) }.delete_if(&:blank?).join(', ')
    end
  end

  %w[cuisine feature offer payment].each do |method|
    define_method "#{method}?" do
      send(method).present?
    end
  end

  def index_suborganizations
    suborganizations.map(&:sunspot_index)
  end

  def self.grouped_collection_for_select
    organizations = Organization.where(:organization_id => nil).order(:title)
  end

  def html_description
    @html_description ||= description.as_html
  end

  def text_description
    @text_description ||= html_description.as_text
  end

  def self.available_suborganization_kinds
    Dir.chdir(Rails.root.join('app/models/suborganizations')) {
      Dir['*.rb'].map { |f| f.gsub('.rb', '') }
    }
  end

  def self.inherited_suborganization_kinds
    available_suborganization_kinds.map(&:classify).map(&:constantize).flat_map(&:descendants).map(&:name).map(&:downcase)
  end

  def self.basic_suborganization_kinds
    available_suborganization_kinds - inherited_suborganization_kinds
  end

  def available_suborganization_kinds
    self.class.available_suborganization_kinds
  end

  def suborganizations
    available_suborganization_kinds.map { |kind| send(kind) }.compact
  end

  def services
    suborganizations.select{ |s| s.respond_to?(:services) }.
      flat_map { |suborganization| suborganization.services }
  end

  def priority_suborganization
    return nil unless priority_suborganization_kind?

    send priority_suborganization_kind
  end

  def rating_position
    count = self.class.count

    self.class.solr_search_ids { order_by(:rating, :desc); paginate(:page => 1, :per_page => count) }.index(id) + 1
  end

  private

  def set_rating
    filling     = summary_rating + nearest_affiches.count + images.count
    popularity  = 0.3 * yandex_metrika_page_views.to_f + vkontakte_likes.to_f

    self.rating = 0.1 * filling + popularity + additional_rating.to_i
  end

  include Rating
  use_for_rating :culture, :entertainment, :meal, :sauna, :sport, :billiard, :creation, :organization_stand
end
