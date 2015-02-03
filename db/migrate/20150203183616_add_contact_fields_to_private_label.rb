class AddContactFieldsToPrivateLabel < ActiveRecord::Migration
  def change
    add_column :private_labels, :email, :string
    add_column :private_labels, :phone, :string
    add_column :private_labels, :address, :string
    add_column :private_labels, :facebook_url, :string
    add_column :private_labels, :twitter_url, :string
    add_column :private_labels, :linkedin_url, :string
  end
end
