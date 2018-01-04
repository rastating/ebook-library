namespace :library do
  desc "Refresh a book's metadata"
  task :refresh, :book_id do |_t, args|
    require 'app/jobs/refresh_metadata_job'

    EBL::Jobs::RefreshMetadataJob.new.perform(args[:book_id], true)
  end
end
