class AddFaviconToPrivateLabels < ActiveRecord::Migration
  def change
    add_attachment :private_labels, :favicon
  end
end
