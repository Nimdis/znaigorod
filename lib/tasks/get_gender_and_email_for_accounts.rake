# encoding: utf-8

require 'progress_bar'

desc 'Get gender and email for accounts'
task :get_gender_and_email_for_accounts => :environment do
  accounts = Account.all
  bar = ProgressBar.new(accounts.count)
  accounts.each do |account|
    if account.users.any?
      user = account.users.first 
      case user.gender
      when 1 || 'female'
        gender = 'female'
      when 2 || 'male'
        gender = 'male'
      else
        gender = nil
      end
      account.update_attributes(gender: gender, email: user.email)
      bar.increment!
    end
  end
end

