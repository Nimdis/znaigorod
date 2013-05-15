desc 'Release tickets'
task :release_tickets => :environment do
  Ticket.reserved.where('updated_at <= ?', Time.now - 30.minutes).map(&:release!)
end

