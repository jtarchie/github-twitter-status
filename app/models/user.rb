class User < ActiveRecord::Base
  attr_accessible :github_uid, :github_token, :github_secret
  attr_accessible :twitter_uid, :twitter_token, :twitter_secret

  def self.active
    where(
      arel_table[:github_uid].not_eq(nil)
    ).where(
      arel_table[:twitter_uid].not_eq(nil)
    )
  end
end
