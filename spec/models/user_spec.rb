require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "is valid with a first name, last name and email, and password" do
    user = User.new(
      first_name: "Aaron",
      last_name:  "Sumner",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    expect(user).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "returns a user's full name as a string" do
    user = FactoryGirl.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end

  it "sends a welcome email on account creation" do
    # .welcome_mail(xxx).deliver_later
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    # The mailer is triggered as part of the user creation process
    user = FactoryGirl.create(:user)
    #spy expect somthing to happedn after somthing(user creation this time) 
    ## expect That UserMailer  to recieved .welcome_email(user) invoked
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end


  it "performs geocoding", vcr: true do
    user = FactoryGirl.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).
      from(nil).
      to("Brooklyn, New York, United States")
  end
end