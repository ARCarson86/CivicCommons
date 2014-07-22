# General Information
json.(person, :id, :name, :slug)
json.location user_path(person, only_path: false)

# Model Methods
json.avatar person.avatar.url :small

# Private Information
if (person == current_person)
  json.(person, :email)
end
