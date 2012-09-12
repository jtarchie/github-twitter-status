class StatusMessage
  class << self
    def generate_all_users!
      time_range = 7.days.ago..Time.now
      User.active.each do |user|
        StatusMessage.new(user, time_range).generate!
      end
    end
  end

  def initialize(user, time_range)
    @user = user
    @time_range = time_range
  end

  def generate!
    github = Github.new(oauth_token: @user.github_token)
    github_current_user  = github.users.get

    commit_events = github_events(github, github_current_user)
    repos = commit_events.collect{ |e| e['repo']['id']}.uniq

    send_tweet(commit_events, repos)
  end

  private

  def github_events(github, github_user)
    events = []
    github.events.performed(github_user['login'], :public => true).each_page do |page|
      events += page
    end

    events.
      select { |e| e["type"] == "PushEvent" }.
      select do |e|
      current_time = Time.parse(e["created_at"])
      @time_range.first.to_i <= current_time.to_i &&
        current_time.to_i <= @time_range.last.to_i
    end
  end

  def send_tweet(commit_events, repos)
    twitter = Twitter::Client.new(
      oauth_token: @user.twitter_token,
      oauth_token_secret: @user.twitter_secret
    )
    tweet = "I have #{commit_events.length} #{"commit".pluralize(commit_events.length)} over #{repos.length} #{"repo".pluralize(repos.length)} this past week."
    twitter.update(tweet)
  end
end