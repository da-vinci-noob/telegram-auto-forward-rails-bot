class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,  :omniauth_providers => [:telegram]
  validates_uniqueness_of :telegram_user_id, allow_nil: true

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, telegram_user_id: auth.uid) do |user|
      user.email = "user_#{auth.uid}@telegram.com"
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.username = auth.info.nickname
      user.photo_url = auth.info.image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
