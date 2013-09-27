# encoding: utf-8

module SearchWithFacets
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :facets

    def facet_field(facet)
      "#{model_name.underscore}_#{facet}"
    end

    def search_with_facets(*args)
      self.facets = args

      delegate :total_rating, :virtual_tour_link, :site?, :images, to: :organization, prefix: true
      delegate :latitude, :longitude, :to => :organization

      klass = self
      searchable do
        facets.each do |facet|
          latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

          string(facet_field(facet), :multiple => true) { self.send(facet).to_s.split(',').map(&:squish).map(&:mb_chars).map(&:downcase) }

          text facet
        end

        float :organization_total_rating

        integer(:organization_ids, multiple: true) { [organization_id] }
        string :organization_title

        # OPTIMIZE: special cases
        boolean(:show_in_search_results) {
          (self.is_a?(Sauna) || self.is_a?(Billiard)) && (self.organization.suborganizations.map(&:class) & [Entertainment]).any? ? false : true
        } if klass == Entertainment

        boolean(:show_in_search_results) {
          self.is_a?(CarWash) && (self.organization.suborganizations.map(&:class) & [CarSalesCenter]).any? ? false : true
        } if klass == CarSalesCenter

        boolean(:with_sauna_halls) { self.with_sauna_halls? } if klass == Sauna
      end
    end
  end

  def stuff
    stuffs = [].tap do |array|
      array << I18n.t('suborganizations.with_3d_tour') if organization.virtual_tour
      array << I18n.t('suborganizations.with_site')    if organization_site?
      array << I18n.t('suborganizations.with_images')  if organization_images.any?
    end

    stuffs.join(', ')
  end
end
