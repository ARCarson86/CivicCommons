# General Information
json.(person, :id, :name)

# Model Methods
json.avatar person.avatar.url

# Private Information
if (person == current_person)
  json.(person, :email)
end
