# encoding: utf-8

class Organization < ActiveRecord::Base
  include HasVirtualTour

  extend FriendlyId

  attr_accessible :address_attributes, :description, :email, :halls_attributes,
                  :images_attributes, :organization_id, :phone, :schedules_attributes,
                  :site, :subdomain, :title, :vfs_path, :attachments_attributes,
                  :logotype_url, :non_cash, :priority_suborganization_kind,
                  :comment, :organization_stand_attributes, :additional_rating,
                  :social_links_attributes, :user_id, :ability_to_comment,
                  :vkontakte_likes, :fb_likes, :odn_likes

  ### <=== CRM

  attr_accessible :primary_organization_id, :balance_delta

  belongs_to :manager, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :organization
  belongs_to :primary_organization, :class_name => 'Organization', :foreign_key => 'primary_organization_id'

  has_many :activities, :dependent => :destroy
  has_many :contacts,   :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :slave_organizations, :class_name => 'Organization', :foreign_key => 'primary_organization_id'

  has_many :gallery_images, :as => :attachable, :dependent => :destroy
  has_many :gallery_files,  :as => :attachable, :dependent => :destroy

  has_many :page_visits, :as => :page_visitable, :dependent => :destroy

  extend Enumerize
  enumerize :status, :in => [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation], default: :fresh, predicates: true

  def update_slave_organization_statuses
    slave_organizations.update_all :status => status
  end

  ### CRM ===>

  ### <=== Payments

  has_many :coupons

  attr_accessible :phone_for_sms, :balance_delta
  attr_accessor :balance_delta

  validates_format_of :phone_for_sms, :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/, :if => :phone_for_sms?

  before_save :update_balance, :if => :balance_delta
  def update_balance
    self.balance = self.balance.to_f + balance_delta.to_f
  end
  private :update_balance

  def enough_balance?
    balance.present? && balance >= Settings['sms_claim.price']
  end

  def sms_claimable?
    phone_for_sms? && enough_balance?
  end

  def claimable_suborganizations
    I18n.t('sms_claim').keys.map { |kind| send(kind) }.compact
  end

  ### Payments ===>

  has_many :afisha,       :through => :showings, :uniq => true
  has_many :halls,          :dependent => :destroy
  has_many :organizations
  has_many :schedules,      :dependent => :destroy
  has_many :sauna_halls,    :through => :sauna
  has_many :showings,       :dependent => :destroy
  has_many :social_links,   :dependent => :destroy

  has_many :visits,         :as => :visitable, :dependent => :destroy, order: 'acts_as_inviter, acts_as_invited'
  has_many :votes,          :as => :voteable, :dependent => :destroy

  has_one :address,             :dependent => :destroy
  has_one :organization_stand,  :dependent => :destroy

  def self.available_suborganization_kinds
    Dir[Rails.root.join('app/models/suborganizations/*.rb')].map { |f| f.split('/').last.gsub '.rb', '' }
  end

  available_suborganization_kinds.each do |kind|
    # без to_sym почему-то не работает добавление фоток к залу сауны
    has_one kind.to_sym, :dependent => :destroy
  end
  has_one :entertainment, :dependent => :destroy, :conditions => { type: nil }

  validates_presence_of :title, :priority_suborganization_kind

  validates  :email, :email_format => {
    :message => I18n.t('activerecord.errors.messages.invalid'),
    :allow_nil => true,
    :allow_blank => true
  }

  validates :site, :format => URI::regexp(%w(http https)), :if => :site?

  validates :phone, :phone => true, :if => :phone?

  accepts_nested_attributes_for :address,             :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :halls,               :reject_if => :all_blank, :allow_destroy => true
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

  alias_attribute :to_s, :title

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
    boolean(:logotyped) { logotype_url? }

    float :rating
    float :total_rating
    string :title

    integer :user_id

    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

    string :status
    string(:suborganizations, :multiple => true) { suborganizations.map(&:class).map(&:name).map(&:underscore) }
    string(:kind, :multiple => true) { ['organization'] }
    string :search_kind

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

  def likes_count
    self.votes.liked.count
  end

  def visit_for_user(user)
    self.visits.find_by_user_id(user.id)
  end

  def create_page_visit(session, user)
    page_visit = self.page_visits.find_or_initialize_by_session(session)
    page_visit.user = user
    page_visit.save
  end

  def search_kind
    self.class.name.underscore
  end

  def term
   "#{title}, #{address}"
  end

  def as_json(options)
    super(:only => :id, :methods => [:term, :latitude, :longitude])
  end

  def nearest_afisha
    Afisha.where :id => Showing.unscoped.where('starts_at > :now AND organization_id = :organization_id',
                  { :now => DateTime.now.utc, :organization_id => id }).group(:afisha_id).pluck(:afisha_id)
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
    suborganizations.map(&:index)
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

  def self.inherited_suborganization_kinds
    available_suborganization_kinds.map(&:classify).map(&:constantize).flat_map(&:descendants).map(&:name).map(&:downcase)
  end

  def self.basic_suborganization_kinds
    available_suborganization_kinds - inherited_suborganization_kinds
  end

  def available_suborganization_kinds
    self.class.available_suborganization_kinds
  end

  def self.available_suborganization_classes
    available_suborganization_kinds.map(&:classify).map(&:constantize)
  end

  def suborganizations
    available_suborganization_kinds.map { |kind| send(kind) }.compact
  end

  def services
    Service.where :id => suborganizations.select{ |s| s.respond_to?(:services) }.flat_map(&:service_ids)
  end

  def priority_suborganization
    return nil unless priority_suborganization_kind?

    send priority_suborganization_kind
  end

  def rating_position
    count = self.class.count

    self.class.solr_search_ids { order_by(:total_rating, :desc); paginate(:page => 1, :per_page => count) }.index(id) + 1
  end

  def images
    gallery_images
  end

  def sold_tickets_count
  end

  def update_rating
    OrganizationObserver.disabled = true
    update_attribute :total_rating, ((client? ? 10 : 0) +
                                     afisha.map {|a| a.copies.sold.count}.sum +
                                     0.5*afisha.actual.count +
                                     0.5*visits.count +
                                     0.1*votes.liked.count +
                                     0.01*page_visits.count)
    OrganizationObserver.disabled = false
  end

end

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
#  total_rating                  :float
#  primary_organization_id       :integer
#  ability_to_comment            :boolean          default(TRUE)
#  phone_for_sms                 :string(255)
#  balance                       :float
#  fb_likes                      :integer
#  odn_likes                     :integer
#

