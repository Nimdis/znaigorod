class My::BetPaymentsController < My::ApplicationController
  actions :new, :create

  belongs_to :afisha, :bet

  defaults :singleton => true

  layout false

  skip_authorization_check

  def create
    create! { |success, failure|
      success.html { render :text => 'find me' and return }
      failure.html { render :new and return }
    }
  end
end
