class AccountPresenter

  def initialize(params)
    @kind_filter = AccountKindFilter.new(params['kind'])
    @gender_filter = AccountGenderFilter.new(params['gender'])
    @page = params['page']
    @page ||= 1
    @per_page = 18
  end

  def kinds_links
    @kinds_links ||= [].tap { |array|
      @kind_filter.available_kind_values.each do |kind|
        array << {
          title: I18n.t("account_kinds.#{kind}"),
          klass: kind,
          parameters: {
            kind: kind
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
            gender: gender
          },
          current: gender == @gender_filter.gender,
        }
      end
    }
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
    %w[female male]
  end

  def available_gender_values
    self.class.available_gender_values
  end

  def gender
    available_gender_values.include?(@gender) ? @gender : 'all'
  end

  available_gender_values.each do |gender|
    define_method "search_#{gender}?" do
      gender == gender
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
    HasSearcher.searcher(:accounts, kind: kind).total
  end
end
