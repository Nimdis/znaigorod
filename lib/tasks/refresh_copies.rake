desc 'Refresh copies'
task :refresh_copies => :environment do
  Copy.reserved.where('updated_at <= ?', Time.now - 30.minutes).map(&:release!)

  Ticket.stale.flat_map(&:copies).map(&:stale!)
  Coupon.stale.flat_map(&:copies).map(&:stale!)
end

