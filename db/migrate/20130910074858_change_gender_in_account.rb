class ChangeGenderInAccount < ActiveRecord::Migration
  def change
    Account.where(gender: nil).update_all(gender: :undefined)
  end
end
