module SocialSignin
  def self.included(receiver)
    receiver.class_eval do
      def setup_identities(user)
        Identity.create_with_oauth(user, session["devise.google_data"]) if session["devise.google_data"]
        Identity.create_with_oauth(user, session["devise.twitter_data"]) if session["devise.twitter_data"]
        Identity.create_with_oauth(user, session["devise.facebook_data"]) if session["devise.facebook_data"]
      end
    end
  end
end