class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_uid
      t.string :github_token
      t.string :github_secret

      t.string :twitter_uid
      t.string :twitter_token
      t.string :twitter_secret

      t.timestamps
    end
  end
end
