namespace :status do
  task generate: :environment do
    StatusMessage.generate_all_users!
  end
end