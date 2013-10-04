desc 'Refresh copies'
task :refresh_copies => :environment do
  Copy.reserved.where('updated_at <= ?', Time.zone.now - 30.minutes).map(&:release!)

  Ticket.for_stale.each do |ticket|
    ticket.emails.each do |email|
      CopyPaymentMailer.delay(:queue => 'mailer').report(email, ticket)
    end if ticket.copies.sold.any?
    ticket.stale!
  end

  Coupon.stale.flat_map(&:copies).map(&:stale!)
end

