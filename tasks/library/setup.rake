namespace :library do
  desc 'Run the setup wizard'
  task :setup do
    require 'lib/ebl/input_handler'
    require 'app/models/setting'

    logger = EBL::Logger.new
    input = EBL::InputHandler.new(logger)
    library_path = nil
    watch_path = nil

    begin
      while library_path.nil?
        library_path = input.get_path(
          '1. Enter the path to the directory which will be used to store ePubs: '
        )
      end

      while watch_path.nil?
        watch_path = input.get_path(
          '2. Enter the path to the directory to watch for new ePubs: '
        )
      end

      EBL::Models::Setting.create_or_update('library_path', library_path)
      EBL::Models::Setting.create_or_update('watch_folder', watch_path)
      logger.log 'Setup complete!', :green
    rescue Interrupt
      puts "\r\nQuitting..."
      next
    end
  end
end
