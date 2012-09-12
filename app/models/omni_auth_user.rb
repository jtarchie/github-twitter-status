class OmniAuthUser
  class << self
    def create(attributes)
      provider = attributes['provider']
      user = User.where("#{provider}_uid" => attributes.uid).first_or_create!

      update_tokens(user, attributes)
    end

    def update(user_id, attributes)
      user = User.find(user_id)
      update_tokens(user, attributes)
    end

    private

    def update_tokens(user, attributes)
      provider = attributes['provider']
      user.send("#{provider}_uid=", attributes.uid)
      user.send("#{provider}_token=", attributes.credentials.token)
      user.send("#{provider}_secret=", attributes.credentials.secret)
      user.save!

      user
    end
  end
end