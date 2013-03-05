# encoding: utf-8

class AfficheCollectionKeywords
  attr_accessor :affiche_collection_presenter

  delegate :all_tags, :kind, :to => :affiche_collection_presenter

  def initialize(affiche_collection_presenter)
    @affiche_collection_presenter = affiche_collection_presenter
  end

  def to_s
    keywords.map(&:mb_chars).map(&:downcase).join(',')
  end

  private

  def keywords
    keywords = []

    keywords << 'aфиша'
    keywords << 'томск'
    keywords << 'киноафиша' if movies?
    keywords << 'расписание сеансов' if movies?

    keywords += categories
    keywords += organization_titles
    keywords += tags
  end

  def categories
    classes = case kind
              when 'affiches'
                Affiche.ordered_descendants
              when 'masterclasses'
                [MasterClass]
              when 'sportsevents'
                [SportsEvent]
              else
                [kind.singularize.classify.constantize]
              end

    classes.map(&:model_name).map(&:human).map(&:mb_chars).map(&:downcase)
  end

  def movies?
    kind == 'movies'
  end

  def tags
    all_tags[0..10]
  end

  def affiche_ids
    search_params = affiche_collection_presenter.send(:search_params)

    affiche_collection_presenter.send(:searcher, search_params).affiches.group(:affiche_id_str).groups.map(&:value).
      map { |id| Affiche.find(id) }
  end

  def organization_titles
    Showing.unscoped.where(:affiche_id => affiche_ids).with_organization.map(&:organization).uniq.
      map(&:title).map { |t| t.split(',').join(' ') }
  end
end
