# encoding: utf-8

require 'vkontakte_api'
require 'curb'

class Afisha < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId

  include VkUpload
  include AutoHtml
  include HasVirtualTour
  include MakePageVisit

  attr_accessible :description, :poster_url, :image_url, :showings_attributes,
                  :tag, :title, :vfs_path, :affiche_schedule_attributes,
                  :images_attributes, :attachments_attributes,
                  :distribution_starts_on, :distribution_ends_on,
                  :original_title, :trailer_code, :vk_aid, :yandex_fotki_url, :constant,
                  :age_min, :age_max, :state_event, :state, :user_id, :kind, :vk_event_url,
                  :fb_likes, :odn_likes, :vkontakte_likes, :poster_vk_id

  belongs_to :user

  has_many :comments,               :dependent => :destroy, :as => :commentable
  has_many :gallery_files,          :dependent => :destroy, :as => :attachable
  has_many :gallery_images,         :dependent => :destroy, :as => :attachable
  has_many :gallery_social_images,  :dependent => :destroy, :as => :attachable
  has_many :invitations,            :dependent => :destroy, :as => :inviteable
  has_many :messages,               :dependent => :destroy, :as => :messageable
  has_many :page_visits,            :dependent => :destroy, :as => :page_visitable
  has_many :showings,               :dependent => :destroy, :order => :starts_at
  has_many :tickets,                :dependent => :destroy
  has_many :versions,               :dependent => :destroy, :as => :versionable, :order => 'id ASC'
  has_many :visits,                 :dependent => :destroy, :as => :visitable
  has_many :votes,                  :dependent => :destroy, :as => :voteable

  has_many :addresses,     :through => :organizations, :uniq => true, :source => :address
  has_many :copies,        :through => :tickets
  has_many :organizations, :through => :showings, :uniq => true

  has_one :affiche_schedule, :dependent => :destroy

  serialize :kind, Array
  enumerize :kind, in: [:movie, :concert, :party, :spectacle, :exhibition, :sportsevent, :masterclass, :competition, :other], multiple: true, predicates: true

  normalize_attribute :kind, with: :blank_array

  validates_presence_of :kind, :title, :description

  accepts_nested_attributes_for :affiche_schedule, :allow_destroy => true, :reject_if => :afisha_schedule_attributes_blank?
  accepts_nested_attributes_for :showings, :allow_destroy => true

  default_scope order('afisha.id DESC')

  scope :latest,           ->(count) { limit(count) }
  scope :with_images,      -> { where('image_url IS NOT NULL') }
  scope :with_showings,    -> { includes(:showings).where('showings.starts_at > :date OR showings.ends_at > :date', { :date => Date.today }) }
  scope :with_event_url,   -> { where('vk_event_url IS NOT NULL') }

  default_value_for :yandex_metrika_page_views, 0
  default_value_for :vkontakte_likes,           0
  default_value_for :total_rating,              0

  before_save :prepare_trailer
  before_save :set_wmode_for_trailer, :if => :published?

  scope :available_for_edit,    -> { where(:state => [:draft, :published]) }
  scope :by_state,              ->(state) { where(:state => state) }
  scope :by_kind,               ->(kind) { where(:kind => kind) }
  scope :draft,                 -> { with_state(:draft) }
  scope :published,             -> { with_state(:published) }
  scope :pending,               -> { with_state(:pending) }
  scope :actual,                -> { includes(:showings).where('showings.starts_at >= ? OR (showings.ends_at is not null AND showings.ends_at > ?)', DateTime.now.beginning_of_day, Time.zone.now).uniq }
  scope :archive,               -> { joins(:showings).where('showings.starts_at < ? OR (showings.ends_at is not null AND showings.ends_at < ?)', DateTime.now.beginning_of_day, Time.zone.now).uniq }

  friendly_id :title, use: :slugged
  normalize_attribute :image_url

  # >>>>>>>>>>>> Wizard  >>>>>>>>>>>>

  attr_accessor :step, :set_region, :crop_x, :crop_y, :crop_width, :crop_height, :social_gallery_url
  attr_accessible :poster_image, :step, :set_region, :crop_x, :crop_y, :crop_width, :crop_height, :social_gallery_url

  def should_generate_new_friendly_id?
    return true if !self.slug? && self.published?

    false
  end

  state_machine :initial => :draft do
    after_transition any => :published do |afisha, transition|
      afisha.send(:set_slug)
    end

    event :send_to_moderation do
      transition :draft => :pending
    end

    event :approve do
      transition [:draft, :pending] => :published
    end

    event :send_to_author do
      transition :published => :draft
    end

    state :published do
      validates_presence_of :showings, :if => Proc.new { |afisha| !afisha.movie? && !afisha.affiche_schedule.present? }
    end
  end

  def self.available_tags(query)
    pluck(:tag).compact.flat_map { |str| str.split(',') }.compact.map(&:squish).uniq.delete_if(&:blank?).select { |str| str =~ /^#{query}/ }.sort
  end

  def self.steps
    %w[first second third fourth fifth sixth]
  end

  steps.each do |step|
    define_method("#{step}_step?") { self.step == step }
  end

  def set_region?
    set_region.present?
  end

  has_attached_file :poster_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :poster_image, :presence => true, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png' },                :if => [:draft?, :second_step?], :unless => :set_region?

  validates :poster_image, :dimensions => { :width_min => 300, :height_min => 300 },    :if => [:draft?, :second_step?], :unless => :set_region?

  after_validation :set_poster_url, :if => :set_region?

  def poster_image_original_dimensions
    @poster_image_original_dimensions ||= {}.tap { |dimensions|
      dimensions[:width] = poster_image_url.match(/\/(?<dimensions>\d+-\d+)\//)[:dimensions].split('-').first.to_i
      dimensions[:height] = poster_image_url.match(/\/(?<dimensions>\d+-\d+)\//)[:dimensions].split('-').last.to_i
    }
  end

  def side_max_size
    580.to_f
  end

  def resize_factor
    @resize_factor = poster_image_original_dimensions.values.max / side_max_size

    (@resize_factor < 1) ? 1.0 : @resize_factor
  end

  def poster_image_resized_dimensions
    return poster_image_original_dimensions if poster_image_original_dimensions.values.max < side_max_size

    {}.tap { |dimensions|
      dimensions[:width] = (poster_image_original_dimensions[:width] / resize_factor).round
      dimensions[:height] = (poster_image_original_dimensions[:height] / resize_factor).round
    }
  end

  def set_poster_url
    if poster_image_url?
      rpl = 'region/' << [crop_width, crop_height, crop_x, crop_y].map(&:to_f).map { |v| v * resize_factor }.map(&:round).join('/')
      self.poster_url = poster_image_url.gsub(/\/\d+-\d+\//, "/#{rpl}/")
    end
  end
  private :set_poster_url

  def ready_for_moderation?
    title.present? && description.present? && poster_image_url? && showings.any? && draft?
  end

  # <<<<<<<<<<<< Wizard  <<<<<<<<<<<

  # >>>>>>>>>>>> Auction >>>>>>>>>>>
  attr_accessible :allow_auction

  has_many :bets, :dependent => :destroy, :order => 'bets.id DESC'

  default_value_for :allow_auction, false

  def price_min
    return 0 if showings.actual.empty?

    return tickets.pluck(:price).min if tickets.any?

    showings.actual.pluck(:price_min).compact.min || 0
  end
  # <<<<<<<<<<<< Auction <<<<<<<<<<<

  after_save :save_images_from_vk,            :if => :vk_aid?
  after_save :save_images_from_yandex_fotki,  :if => :yandex_fotki_url?

  alias_attribute :to_s,            :title
  alias_attribute :tag_ru,          :tag
  alias_attribute :title_ru,        :title
  alias_attribute :title_translit,  :title
  alias_attribute :rating, :total_rating

  searchable do
    float :rating

    float :age_min
    float :age_max

    string :search_kind
    string :state
    string(:inviteable_categories, :multiple => true) { Inviteables.instance.categories_for_afisha(self) if actual? }
    string(:kind, :multiple => true) { kind.map(&:value) }

    text :title,                :boost => 1.0 * 1.2
    text :title_ru,             :boost => 1.0,        :more_like_this => true
    text :title_translit,       :boost => 0.0,                                  :stored => true
    text :original_title,       :boost => 1.5,        :more_like_this => true,  :stored => true
    text :human_model_name,     :boost => 0.5 * 1.2
    text :human_model_name_ru,  :boost => 0.5
    text :tag,                  :boost => 0.5 * 1.2
    text :tag_ru,               :boost => 0.5,        :more_like_this => true,  :stored => true
    text :place,                :boost => 0.5 * 1.2
    text :place_ru,             :boost => 0.5
    text :address,              :boost => 0.3 * 1.2
    text :address_ru,           :boost => 0.3
    text :description,          :boost => 0.1 * 1.2                                               do text_description end
    text :description_ru,       :boost => 0.1,                                  :stored => true   do text_description end

    boolean :has_images, :using => :has_images?

    time :last_showing_time,  :trie => true
    date :created_at

    text :title, :as => :term_text
  end

  def actual?
    self.showings.actual.any?
  end

  def search_kind
    self.class.name.underscore
  end

  def has_visit_for?(user)
    visits.where(:user_id => user).any?
  end

  def visit_for(user)
    visits.find_by_user_id(user)
  end

  def invitations_and_visits_grouped_by_account
    {}.tap do |hash|
      visits.each do |visit|
        hash[visit.user.account] = {}
        hash[visit.user.account][:visit] = visit
        hash[visit.user.account][:invitations] = visit.user.account.invitations.without_invited.where(:inviteable_type => self.class.name, :inviteable_id => id)
      end
    end
  end

  def likes_count
    self.votes.liked.count
  end

  def get_vk_event_id
    self.vk_event_url.split('/').last.gsub(/event/, '')
  end

  def update_rating
    update_attribute :total_rating, (copies.sold.count +
                                     0.5*visits.count +
                                     0.1*votes.liked.count +
                                     0.01*page_visits.count)
  end

  def human_model_name
    self.class.model_name.human
  end

  alias_attribute :human_model_name_ru, :human_model_name

  def self.ordered_descendants
    kind.values
  end

  def tags
    tag.to_s.split(/,\s+/).map(&:mb_chars).map(&:downcase).map(&:squish)
  end

  def address
    addresses.uniq.join(' ')
  end

  def place
    showings.pluck(:place).uniq.join(' ')
  end

  alias_method :address_ru, :address
  alias_method :place_ru,   :place

  def first_showing
    showings.first
  end

  def first_showing_time
    first_showing.try(:starts_at)
  end

  def last_showing
    showings.last
  end

  def last_showing_time
    last_showing.try(:ends_at) || last_showing.try(:starts_at)
  end

  def create_showing(attributes)
    showings.create attributes
  end

  def has_tickets_for_sale?
    tickets.available.any?
  end

  def max_tickets_discount
    tickets.joins(:copies).where('copies.state = ?', :for_sale).map(&:discount).sort.last
  end

  def destroy_showings
    showings.destroy_all
  end

  def has_images?
    images.any?
  end

  def images
    [gallery_images, gallery_social_images].flatten
  end

  def html_description
    @html_description ||= description.to_s.as_html
  end

  auto_html_for :description do
    youtube(:width => 580, :height => 350)
    vimeo(:width => 580, :height => 350)
    redcloth :target => '_blank', :rel => 'nofollow'
  end

  def text_description
    @text_description ||= html_description.as_text
  end

  def self.trailer_auto_html(trailer_code)
    AutoHtml.auto_html(trailer_code) do
      youtube(:width => 580, :height => 350)
      vimeo(:width => 580, :height => 350)
      link(:target => '_blank', :rel => 'nofollow')
    end
  end

  # Afisha movie kind #
  def premiere?
    distribution_starts_on && distribution_starts_on >= Date.today.beginning_of_week && distribution_starts_on <= Date.today.end_of_week && showings.count >= 5
  end

  def movie?
    kind.include?('movie')
  end

  def reindex_showings
    showings.actual.map(&:index)
  end

  def ignore_fields
    [ :created_at,
      :id,
      :popularity,
      :poster_image_content_type,
      :poster_image_file_name,
      :poster_image_file_size,
      :poster_image_updated_at,
      :poster_image_url,
      :slug,
      :state,
      :total_rating,
      :updated_at,
      :user_id,
      :vkontakte_likes,
      :yandex_metrika_page_views,
      :vfs_path
    ]
  end

  def change_versionable?
    self.changed? && (self.changes.keys.map(&:to_sym) - ignore_fields).any?
  end

  def save_version
    self.versions.create!(:body => self.changes.to_json(:except => ignore_fields))
  end

  # >>>>>>>>>>>> Poster to VK >>>>>>>>>>>
  def check_poster_changed?
    version = JSON.parse(self.versions.last.body) if self.versions.any?

    return true if version && version.has_key?('poster_url')

    false
  end

  def vk_client
    VkontakteApi::Client.new(User.find(9).token)
  end

  def vk_album_id(client)
    album_title = "Афиши #{I18n.l(Time.zone.today, :format => '%B-%Y')}"
    album_id = nil
    album = client.photos.get_albums(owner_id: -58652180).select{|g| g.title == album_title}

    if album.one?
      album_id = album.first.aid
    else
      album_id = create_vk_album(client)
    end

    album_id
  end

  def create_vk_album(client)
    album = client.photos.create_album(title: "Афиши #{I18n.l(Time.zone.today, :format => '%B-%Y')}", group_id: 58652180, comment_privacy: 1, privacy: 1)
    album.aid
  end

  def upload_poster_to_vk
    client = vk_client
    begin
      album_id = vk_album_id(client)
      up_serv = client.photos.get_upload_server(aid: album_id, group_id: 58652180)
      file = Tempfile.new([self.slug,'.jpg'])
      file.binmode
      file.write open(poster_url).read
      upload = VkontakteApi.upload(url: up_serv.upload_url, photo: [file.path, 'image/jpeg'])
      photo = client.photos.save(upload)
      file.close!
      photo_vk_id = "photo#{photo.first.owner_id}_#{photo.first.pid}"
      self.update_column(:poster_vk_id, photo_vk_id)
      client.photos.edit(oid: photo.first.owner_id, photo_id: photo.first.pid, caption: self.title)
    rescue VkontakteApi::Error => e
    end
  end
  # <<<<<<<<<<<< Poster to VK <<<<<<<<<<<

  private

  def afisha_schedule_attributes_blank?(attributes)
    %w[ends_at ends_on starts_at starts_on].each do |attribute|
      return false unless attributes[attribute].blank?
    end

    true
  end

  def save_images_from_vk
    return unless changes.keys.include?('vk_aid')
    get_images_from_vk.each do |image_hash|
      self.gallery_social_images.find_or_initialize_by_file_url_and_thumbnail_url(
        :file_url => (image_hash['photo']['src_xbig'].present? ? image_hash['photo']['src_xbig'] : image_hash['photo']['src_big']),
        :thumbnail_url => image_hash['photo']['src']
      ).tap do |image|
        image.width  = image_hash['photo']['width']
        image.height = image_hash['photo']['height']

        next if image.width.nil? || image.height.nil?

        image.description = image_hash['photo']['text']
        image.save(:validate => false)
      end
    end
  end

  def get_images_from_vk
    id, aid = vk_aid.split('_')

    photos = []

    response = Curl.get(prepare_url_4_vk({ uid: id, aid: aid })).body_str.gsub(/{"error":".+"}/, '')

    if response.empty?
      response = Curl.get(prepare_url_4_vk({ gid: id, aid: aid })).body_str.gsub(/{"error":".+"}/, '')
    end

    return [] if response.blank?

    photos = JSON.parse(response)['response']
  end

  def prepare_url_4_vk(options)
    vk_app_id = Settings['vk.app_id']
    vk_app_secret = Settings['vk.app_secret']

    params = { api_id: vk_app_id, format: 'JSON', method: 'photos.get' }.merge(options).sort

    sig = Digest::MD5.hexdigest(params.map{|k,v| "#{k}=#{v}"}.join + vk_app_secret)

    return "http://api.vk.com/api.php?#{params.map{|k,v| "#{k}=#{v}"}.join('&')}&sig=#{sig}"
  end

  def save_images_from_yandex_fotki
    return unless changes.keys.include?('yandex_fotki_url')
    get_images_from_yandex_fotki.each do |image_hash|
      image_hash = image_hash['img']

      self.gallery_social_images.find_or_initialize_by_file_url_and_thumbnail_url(:file_url => image_hash.keys.include?('XXL') ? image_hash['XXL']['href'] : image_hash['orig']['href'], :thumbnail_url => image_hash['M']['href']).tap do |image|
        image.width  = image_hash.keys.include?('XXL') ? image_hash['XXL']['width'] : image_hash['orig']['width']
        image.height = image_hash.keys.include?('XXL') ? image_hash['XXL']['height'] : image_hash['orig']['height']
        image.description = image_hash['summary'] || ''
        image.save(:validate => false)
      end
    end
  end

  def get_images_from_yandex_fotki
    JSON.parse(Curl.get("http://api-fotki.yandex.ru/api/users/#{yandex_fotki_url}/photos/?format=json").body_str)['entries']
  end

  def prepare_trailer
    self.trailer_code.to_s.gsub!(/width=("|')(\d+)("|')/i, 'width="740"')
    self.trailer_code.to_s.gsub!(/height=("|')(\d+)("|')/i, 'height="450"')
  end

  def set_wmode_for_trailer
    self.trailer_code.gsub!(/(object|embed)/, '\1 wmode="opaque"') if self.trailer_code?
  end

end

# == Schema Information
#
# Table name: afisha
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  description               :text
#  original_title            :string(255)
#  poster_url                :text
#  trailer_code              :text
#  tag                       :text
#  vfs_path                  :string(255)
#  image_url                 :text
#  distribution_starts_on    :datetime
#  distribution_ends_on      :datetime
#  slug                      :string(255)
#  constant                  :boolean
#  yandex_metrika_page_views :integer
#  vkontakte_likes           :integer
#  vk_aid                    :string(255)
#  yandex_fotki_url          :string(255)
#  popularity                :float
#  age_min                   :float
#  age_max                   :float
#  total_rating              :float
#  state                     :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_url          :text
#  user_id                   :integer
#  kind                      :text
#  vk_event_url              :string(255)
#  fb_likes                  :integer
#  odn_likes                 :integer
#  allow_auction             :boolean
#  poster_vk_id              :string(255)
#

