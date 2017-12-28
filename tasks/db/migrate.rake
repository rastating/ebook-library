namespace :db do
  desc 'Run database migrations'
  task :migrate, [:version] do |_t, args|
    logger = EBL::Logger.new
    logger.context = 'db:migrate'

    Sequel.extension :migration
    db = Sequel::Model.db

    if args[:version]
      logger.log "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, 'db/migrations', target: args[:version].to_i)
    else
      logger.log 'Migrating to latest'
      Sequel::Migrator.run(db, 'db/migrations')
    end

    logger.log 'Migration complete', :green
  end
end
