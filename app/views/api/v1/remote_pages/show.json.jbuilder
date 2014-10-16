json.(@remote_page, :id, :url, :title, :description, :created_at, :updated_at)

json.number_of_top_level_contributions @remote_page.top_level_contributions.count
json.number_of_contributions @remote_page.contributions.count
