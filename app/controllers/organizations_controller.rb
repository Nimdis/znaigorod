class OrganizationsController < InheritedResourcesController
  actions :index, :show

  helper_method :params_with_facet, :params_without_facet, :params_have_facet?

  layout 'public'

  respond_to :json

  def index
    index! {
      if request.xhr?
        render :action => 'index', :layout => false and return
      end
    }
  end

  protected
    def collection
      @search ||= Organization.search do
        fulltext params[:q]

        all_of do
          Organization.facets.each do |facet|
            params_facet_values(facet).each do |value|
              with(facet, value)
            end
          end

          with(:capacity).greater_than(capacity) if capacity?
        end

        Organization.facets.each do |facet|
          facet(facet, :zeros => true, :sort => :index)
        end
      end

      @search.results
    end

    def capacity
      params[:capacity].to_i
    end

    def capacity?
      capacity > 0
    end

    def params_facet_values(facet)
      [*params[:facets].try(:[], facet)]
    end

    def params_have_facet?(facet, value)
      params_facet_values(facet).include? value
    end

    def request_parameters
      Marshal.load(Marshal.dump(request.env['rack.request.query_hash'].symbolize_keys))
    end

    def params_with_facet(facet, value)
      request_parameters.tap do | parameters |
        parameters[:facets] ||= {}
        parameters[:facets][facet] ||= []
        parameters[:facets][facet] << value
        parameters[:facets][facet].uniq!
      end
    end

    def params_without_facet(facet, value)
      request_parameters.tap do | parameters |
        parameters[:facets][facet].uniq!
        parameters[:facets][facet].delete(value)
      end
    end
end
