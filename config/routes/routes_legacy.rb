# encoding: utf-8

Znaigorod::Application.routes.draw do

  get '/affiches', :to => redirect('/afisha')

  Afisha.kind.values.map(&:pluralize).each do |kind|
    get kind => 'afisha#index', :as => kind, :defaults => { :categories => [kind.singularize], :hide_categories => true }
    match "/#{kind}/all" => redirect("/#{kind}")
  end

  Afisha.kind.values.each do |kind|
    get "#{kind}/:id", :to => redirect { |params, req|
      "/afisha/#{params[:id]}"
    }
    get "#{kind}/:id/photogallery", :to => redirect { |params, req|
      "/afisha/#{params[:id]}#photogallery"
    }
    get "#{kind}/:id/trailer", :to => redirect { |params, req|
      "/afisha/#{params[:id]}#trailer"
    }
  end

  get ':kind/:period/(:on)/(categories/*categories)/(tags/*tags)',
    :kind => /movies|concerts|parties|spectacles|exhibitions|sportsevents|others|affiches|masterclasses/,
    :period => /today|weekly|weekend|all|daily/,
    :to => redirect { |params, req|
      parameters = {}
      parameters['categories'] = []
      (params[:categories] || params[:kind] || "").split('/').each do |word|
        parameters['categories'] << word
      end
      period = case params[:period]
               when 'weekly'
                 'week'
               when 'daly'
                 'all'
               else
                 params[:period]
               end
      url = "/afisha?order_by=popularity&view=posters"
      url += "&period=#{period}"
      parameters['categories'].each do |cat|
        url += "&categories[]=#{cat.singularize}"
      end
      URI.encode(url)
    }

  get ':organization_class/(:category)/(*query)',
    :organization_class => /meals|entertainments|cultures|sports|creations|saunas/,
    :to => redirect { |params, req|
      url = "/#{params[:organization_class]}?order_by=popularity"
      if params[:category] == 'all'
        parameters = {}
        parameters.tap do |hash|
          keyword = ''
          params[:query].split('/').each do |word|
            keyword = word and hash[keyword] ||= [] and next if ['categories'].include?(word)
            hash[keyword] << word if hash[keyword]
          end
        end
        parameters['categories'] ||= []
        if parameters['categories'] == ['сауны']
          url = '/saunas'
        else
          parameters['categories'].each do |cat|
            url += "&categories[]=#{cat}"
          end
        end
      else
        if params[:category] == 'сауны'
          url = '/saunas'
        else
          url += "&categories[]=#{params[:category]}"
        end
      end
      URI.encode(url)
  }

  get 'organizations/:id/affiche/all' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }

  get 'organizations/:id/tour' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }

  get 'organizations/:id/photogallery' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }

end
