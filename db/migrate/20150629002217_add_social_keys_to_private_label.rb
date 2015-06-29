class AddSocialKeysToPrivateLabel < ActiveRecord::Migration
  def change
    add_column :private_labels, :fb_api_key, :string
    add_column :private_labels, :fb_app_secret, :string
    add_column :private_labels, :google_client_id, :string
    add_column :private_labels, :google_client_secret, :string
    add_column :private_labels, :linkedin_api_key, :string
    add_column :private_labels, :linkedin_secret_key, :string
    add_column :private_labels, :twitter_api_key, :string
    add_column :private_labels, :twitter_api_secret, :string
  end
end
