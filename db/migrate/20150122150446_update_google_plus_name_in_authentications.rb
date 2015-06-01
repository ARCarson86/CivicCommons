class UpdateGooglePlusNameInAuthentications < ActiveRecord::Migration
  def up
    Authentication.where(provider: :google_oauth2).update_all(provider: :google_plus)
  end

  def down
    Authentication.where(provider: :google_plus).update_all(provider: :google_oauth2)
  end
end
