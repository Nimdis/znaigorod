# encoding: utf-8

class Photogallery
  include Rails.application.routes.url_helpers
  include ActionView::Helpers

  attr_accessor :period, :query

  def initialize(params = {})
    @period = params[:period] || 'all'
    @query = params[:query] || ''
  end

  def main_menu_link
    Link.new title: 'Фотогалереи', url: photogalleries_path(period: 'all')
  end

  def reports_for_main_page
    PhotoreportDecorator.decorate total_groups.groups[0..2].map(&:value).map { |id| Affiche.find(id) }
  end

  def period_links
    [].tap do |links|
      links << Link.new(title: "#{I18n.t('photoreport_periods.weekly')} (#{week_groups_count})", url: photogalleries_path(period: 'week'))
      links << Link.new(title: "#{I18n.t('photoreport_periods.monthly')} (#{month_groups_count})", url: photogalleries_path(period: 'month'))
      links << Link.new(title: "#{I18n.t('photoreport_periods.total')} (#{total_groups_count})", url: photogalleries_path(period: 'all'))
    end
  end

  def category_links
    [].tap do |links|
      all_available_categories.each do |category|
        html_options = {}.tap do |opts|
          opts[:class] = 'selected' if params_categories.include?(category)
          opts[:class] = 'disabled' unless current_categories.include?(category)
        end

        links << content_tag(:li,
                             Link.new(title: category,
                                      url: photogalleries_path(period: period, query: query_for(category, nil)),
                                      html_options: html_options),
                             html_options)
      end
    end
  end

  def tag_links
    [].tap do |links|
      all_available_tags.each do |tag|
        html_options = {}.tap do |opts|
          opts[:class] = 'selected' if params_tags.include?(tag)
          opts[:class] = 'disabled' unless current_tags.include?(tag)
        end

        links << content_tag(:li,
                             Link.new(title: tag,
                                      url: photogalleries_path(period: period, query: query_for(nil, tag)),
                                      html_options: html_options),
                             html_options)
      end
    end
  end

  def collection
    PhotoreportDecorator.decorate raw_collection
  end

  private

  def key_words
    %w[categories tags]
  end

  def query_to_hash
    {}.tap do |hash|
      key_word = ''

      query.split('/').each do |word|
        key_word = word and hash[word] ||= [] and next if key_words.include?(word)
        hash[key_word] << word
      end
    end
  end

  def params_categories
    query_to_hash['categories'] || []
  end

  def params_tags
    query_to_hash['tags'] || []
  end

  def searcher(search_params = {})
    HasSearcher.searcher(:photoreport, search_params)
  end

  def total_groups(search_params = {})
    searcher(search_params).grouped.group(:imageable_id_str)
  end

  def week_groups(search_params = {})
    searcher(search_params).weekly.grouped.group(:imageable_id_str)
  end

  def month_groups(search_params = {})
    searcher(search_params).monthly.grouped.group(:imageable_id_str)
  end

  def total_groups_count
    total_groups.total
  end

  def week_groups_count
    week_groups.total
  end

  def month_groups_count
    month_groups.total
  end

  def all_available_categories
    searcher.facet(:category).rows.map(&:value)
  end

  def all_available_tags
    searcher.facet(:tags).rows.map(&:value)
  end

  def search_params
    {}.tap do |params|
      params[:category] = params_categories unless params_categories.empty?
      params[:tags] = params_tags unless params_tags.empty?
    end
  end

  def current_categories
    searcher(search_params).facet(:category).rows.map(&:value)
  end

  def current_tags
    searcher(search_params).facet(:tags).rows.map(&:value)
  end

  def raw_collection
    groups = case period
             when 'all'
               total_groups(search_params)
             when 'week'
               week_groups
             when 'month'
               month_groups
             end
    groups.groups.map(&:value).map { |id| Affiche.find(id) }
  end

  def query_array_for_category(category)
    categories = params_categories.clone
    categories.delete(category)

    (params_categories.include?(category) ? categories : categories + [category]).tap do |array|
      array.unshift('categories') if array.any?
    end
  end

  def query_array_for_tag(tag)
    tags = params_tags.clone
    tags.delete(tag)

    (params_tags.include?(tag) ? tags : tags + [tag]).tap do |array|
      array.unshift('tags') if array.any?
    end
  end

  def query_for(category, tag)
    (query_array_for_category(category) + query_array_for_tag(tag)).compact.join('/')
  end
end
