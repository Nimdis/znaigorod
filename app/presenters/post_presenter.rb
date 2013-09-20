class PostPresenter

  def initialize(params)
    @kind_filter      = PostKindFilter.new(params['kind'])
    @sorting_filter   = PostSortingFilter.new(params['order_by'])
    @page = params['page']
    @page ||= 1
    @per_page = 15
  end

  def kinds_links
    @kinds_links ||= [].tap { |array|
      @kind_filter.available_kind_values.each do |kind|
        array << {
          title: I18n.t("post_kinds.#{kind}"),
          klass: kind,
          parameters: {
            kind: kind,
            order_by: @sorting_filter.order_by
          },
          current: kind == @kind_filter.kind,
          count: PostCounter.new(self, kind).count
        }
      end
    }
  end

  def sortings_links
    @sortings_links ||= [].tap { |array|
      @sorting_filter.available_sortings_values.each do |sorting_value|
        array << {
          title: I18n.t("post.sort.#{sorting_value}"),
          url: "posts_path",
          parameters: {
            :kind => @kind_filter.kind,
            :order_by => sorting_value
          },
          selected: @sorting_filter.order_by == sorting_value
        }
      end
    }
  end

  def collection
    PostDecorator.decorate searcher.paginate(:page => @page, :per_page => @per_page)
  end

  def searcher_params
    @searcher_params ||= {}.tap do |searcher_params|
      searcher_params[:kind] = @kind_filter.kind if @kind_filter.used?
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:posts, searcher_params).send("order_by_#{@sorting_filter.order_by}")
  end



end

class PostKindFilter

  attr_accessor :kind

  def initialize(kind)
    @kind = kind
  end

  def self.available_kind_values
    %w[all photoreport review]
  end

  def available_kind_values
    self.class.available_kind_values
  end

  def kind
    available_kind_values.include?(@kind) ? @kind : 'all'
  end

  def used?
    kind != 'all'
  end

  available_kind_values.each do |kind|
    define_method "search_#{kind}?" do
      kind == kind
    end
  end
end

class PostSortingFilter
  def initialize(sorting)
    @order_by = sorting
  end

  def self.available_sortings_values
    %w[creation rating]
  end

  def available_sortings_values
    sortings = %w[creation rating]
  end

  available_sortings_values.each do |sorting|
    define_method "sort_by_#{sorting}?" do
      @order_by == sorting
    end
  end

  def order_by
    @order_by ||= available_sortings_values.include?(@order_by) ? @order_by : 'rating'
  end
end

class PostCounter
  attr_accessor :presenter, :kind

  def initialize(presenter, kind)
    @presenter = presenter
    @kind = kind
    @kind = nil if kind == 'all'
  end

  def count
    HasSearcher.searcher(:posts, kind: kind).total
  end
end
