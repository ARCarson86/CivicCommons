RSpec.shared_examples 'it allows editing their own account' do 
  it 'allows them to read their own account' do
    expect(ability.can? :read, person).to be_truthy
  end

  it 'allows them to update their own account' do
    expect(ability.can? :update, person).to be_truthy
  end

  it 'does not allow them to manage another person' do
    other_person = create(:person)
    expect(ability.can? :create, Person).to be_falsey
    expect(ability.can? :update, other_person).to be_falsey
    expect(ability.can? :destroy, other_person).to be_falsey
  end
end
