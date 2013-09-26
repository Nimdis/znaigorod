desc "Send ticket statistics"
task :send_ticket_statistics => :environment do
  Ticket.stale.with_emails.without_report.each do |ticket|
    ticket.emails.each do |email|
      CopyPaymentMailer.delay(:queue => 'mailer').report(email, ticket)
    end if ticket.copies.sold.any?
  end
end
