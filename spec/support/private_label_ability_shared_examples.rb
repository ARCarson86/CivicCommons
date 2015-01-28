RSpec.shared_examples 'it allows editing their own account' do 
  it 'allows them to read their own account' do
    expect(ability.can? :read, person).to be_truthy
  end

  it 'allows them to update their own account' do
    expect(ability.can? :update, person).to be_truthy
  end
end
