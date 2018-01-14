namespace :library do
  desc 'Scan the watch folder for new books'
  task :scan do
    require 'app/jobs/epub_scan_job'
    require 'app/models/setting'

    watch_folder = EBL::Models::Setting.first(key: 'watch_folder').value
    job = EBL::Jobs::EpubScanJob.new
    job.sync_refresh = true
    job.perform(watch_folder)
  end
end
