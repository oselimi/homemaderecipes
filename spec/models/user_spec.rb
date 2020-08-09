require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, email: 'JOHN@LIVE.COM') }
  
  before { user }

  describe "associations" do
    it { should have_many(:recipes).dependent(:destroy) }
    it { should have_many(:instructions).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:handle_name) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:handle_name).is_at_most(User::MAX_LENGTH_HANDLE_NAME) }
    it { should validate_length_of(:first_name).is_at_most(User::MAX_LENGTH_FIRST_NAME) }
    it { should validate_length_of(:last_name).is_at_most(User::MAX_LENGTH_LAST_NAME) }
    it { should validate_length_of(:email).is_at_most(User::MAX_LENGTH_EMIAL) }
    it { should validate_length_of(:password).is_at_least(User::MIN_LENGTH_PASSWORD) }
    it { should have_secure_password}
    
    context "when matching uniqueness of handle name and email" do
      it { should validate_uniqueness_of(:handle_name) }
      it { should validate_uniqueness_of(:email) }
    end

    context "email format" do
      it "should be valid" do
        addresses = %w[user@exmaple.com User@example.com e@ss.com example_2@live.com]
        addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
      it "should be invalid" do
        addresses = %w[examole.com example@axample,com user@example]
        addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).not_to be_valid
        end
      end
    end
  end

  describe "before save email" do
    it "email format should be downcase" do
      expect(user.email).to eq 'john@live.com'
    end
  end
end
