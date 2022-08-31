require 'rails_helper'

RSpec.describe User, type: :model do
  it 'passes the e-mail address' do
    user = create(:random_user)
    expect(user).to be_valid
  end

  it 'does not pass an invalid e-mail address' do
    user = User.new(name: 'jdoe', email: 'invalid', password: 'password', password_confirmation: 'password')
    expect(user).to_not be_valid
  end

end
