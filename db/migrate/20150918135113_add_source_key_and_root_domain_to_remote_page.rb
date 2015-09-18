class AddSourceKeyAndRootDomainToRemotePage < ActiveRecord::Migration
  def change
    add_column :remote_pages, :source_key, :string
    add_column :remote_pages, :root_domain, :string
  end
end
