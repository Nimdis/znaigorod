class Service < ActiveRecord::Base
  extend Enumerize

  attr_accessible :age, :title, :feature, :category, :description, :kind, :prices_attributes

  belongs_to :context, polymorphic: true

  validates_presence_of :title

  before_save :set_min_value

  alias_attribute :to_s, :title

  has_many :prices, dependent: :destroy
  accepts_nested_attributes_for :prices, allow_destroy: true

  delegate :index, to: :context, prefix: true

  after_save :context_index

  validates_presence_of :kind

  normalize_attributes :feature, :title, with: :blank

  scope :filled, -> { where('title IS NOT NULL') }

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    validates_presence: true,
    message: I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked'),
    available_values: []

  presents_as_checkboxes :offer, available_values: []

  enumerize :kind, in: [:visiting, :lesson, :washing], predicates: true

  private

  def set_min_value
    self.min_value = prices.map { |p| p.single? ? p.value : p.value / p.count }.min
  end
end

# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  title        :text
#  feature      :text
#  age          :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  category     :text
#  description  :text
#

