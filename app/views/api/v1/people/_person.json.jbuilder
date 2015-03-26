# General Information
json.(person, :id, :name, :slug, :first_name)
json.location user_path(person, only_path: false)

# Model Methods
json.avatar person.avatar_image_url

# Private Information
if (person == current_person)
  json.(person, :email)
  if (person.admin?)
    json.admin true
  end
end
