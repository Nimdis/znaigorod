class AccountPresenter
  attr_accessor :gender_filter, :kind_filter, :acts_as_filter

  def initialize(params)
    @kind_filter = AccountKindFilter.new(params['kind'])
    @gender_filter = AccountGenderFilter.new(params['gender'])
    @acts_as_filter = AccountActsAsFilter.new(params['acts_as'])
    @page = params['page'] || 1
  end

  def kinds_links
    @kinds_links ||= [].tap { |array|
      @kind_filter.available_kind_values.each do |kind|
        array << {
          title: I18n.t("account_kinds.#{kind}"),
          klass: kind,
          parameters: {
            kind: kind,
            gender: @gender_filter.gender
          },
          current: kind == @kind_filter.kind,
          count: AccountCounter.new(self, kind).count
        }
      end
    }
  end

  def gender_links
    @genders_links ||= [].tap { |array|
      @gender_filter.available_gender_values.each do |gender|
        array << {
          title: I18n.t("account_genders.#{gender}"),
          klass: gender,
          parameters: {
            gender: gender == 'all' ? nil : gender,
            kind: kind_filter.kind
          },
          current: gender == @gender_filter.gender,
        }
      end
    }
  end

  def acts_as_links
    @acts_ass_links ||= [].tap { |array|
      @acts_as_filter.available_acts_as_values.each do |acts_as|
        array << {
          title: I18n.t("account_acts_as.#{acts_as}"),
          klass: acts_as,
          parameters: {
            kind: @kind_filter.kind,
            gender: @gender_filter.gender,
            acts_as: acts_as == @acts_as_filter.acts_as ? nil : acts_as,
          },
          current: acts_as == @acts_as_filter.acts_as,
        }
      end
    }
  end

  def searcher_params
    @searcher_params ||= {}.tap do |searcher_params|
      searcher_params[:kind] = kind_filter.kind if kind_filter.used?
      searcher_params[:gender] = gender_filter.gender if gender_filter.used?
      searcher_params[:acts_as] = acts_as_filter.acts_as if acts_as_filter.used?
    end
  end

  def collection
    HasSearcher.searcher(:accounts, searcher_params).paginate(:page => @page, :per_page => 18)
  end
end

class AccountKindFilter

  attr_accessor :kind

  def initialize(kind)
    @kind = kind
  end

  def self.available_kind_values
    %w[all admin afisha_editor]
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

class AccountGenderFilter

  attr_accessor :gender

  def initialize(gender)
    @gender = gender
  end

  def self.available_gender_values
    %w[all female male]
  end

  def available_gender_values
    self.class.available_gender_values
  end

  def gender
    available_gender_values.include?(@gender) ? @gender : 'all'
  end

  def used?
    gender != 'all'
  end

  available_gender_values.each do |gender|
    define_method "search_#{gender}?" do
      gender == gender
    end
  end
end

class AccountActsAsFilter

  attr_accessor :acts_as

  def initialize(acts_as)
    @acts_as = acts_as
  end

  def self.available_acts_as_values
    %w[inviter invited]
  end

  def available_acts_as_values
    self.class.available_acts_as_values
  end

  def acts_as
    available_acts_as_values.include?(@acts_as) ? @acts_as : 'all'
  end

  def used?
    acts_as != 'all'
  end

  available_acts_as_values.each do |acts_as|
    define_method "search_#{acts_as}?" do
      acts_as == acts_as
    end
  end
end

class AccountCounter
  attr_accessor :presenter, :kind

  def initialize(presenter, kind)
    @presenter = presenter
    @kind = kind
    @kind = nil if kind == 'all'
  end

  def count
    HasSearcher.searcher(:accounts, presenter.searcher_params.merge(:kind => @kind)).total
  end
end
