module SearchWithFacets
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :facets

    def facet_field(facet)
      "#{model_name.underscore}_#{facet}"
    end

    def search_with_facets(*args)
      self.facets = args

      delegate :rating, :tour_link?, :site?, :images, to: :organization, prefix: true
      delegate :latitude, :longitude, :to => :organization

      klass = self
      searchable do
        facets.each do |facet|
          latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

          string(facet_field(facet), :multiple => true) { self.send(facet).to_s.split(',').map(&:squish).map(&:mb_chars).map(&:downcase) }

          text facet
        end

        float :organization_rating

        integer(:organization_ids, multiple: true) { [organization_id] }

        # TODO: dirty ;(
        boolean(:with_sauna_halls) { self.with_sauna_halls? } if klass == Sauna
        string(:entertainment_type) { self.type } if klass == Entertainment
      end
    end
  end

  def stuff
    stuffs = [].tap do |array|
      array << I18n.t('suborganizations.with_3d_tour') if organization_tour_link?
      array << I18n.t('suborganizations.with_site')    if organization_site?
      array << I18n.t('suborganizations.with_images')  if organization_images.any?
    end

    stuffs.join(', ')
  end
end
