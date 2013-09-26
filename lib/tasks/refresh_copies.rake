desc 'Refresh copies'
task :refresh_copies => :environment do
  Copy.reserved.where('updated_at <= ?', Time.zone.now - 30.minutes).map(&:release!)

  Ticket.for_stale.map(&:stale!)
  Coupon.stale.flat_map(&:copies).map(&:stale!)
end

