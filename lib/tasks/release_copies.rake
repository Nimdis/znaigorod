desc 'Release copies'
task :release_copies => :environment do
  Copy.reserved.where('updated_at <= ?', Time.now - 30.minutes).map(&:release!)
end

